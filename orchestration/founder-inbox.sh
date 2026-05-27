#!/usr/bin/env bash
#
# founder-inbox.sh — Human attention aggregator for Deliberate_Agents
#
# Pure bash polling daemon (zero AI cost). Renders a terminal TUI that
# shows items needing founder attention, tracks completion history,
# and sends macOS notifications for new critical items.
#
# Usage: founder-inbox.sh <config-file>

set -euo pipefail

CONFIG_FILE="${1:?Usage: founder-inbox.sh <config-file>}"

[[ -f "$CONFIG_FILE" ]] || { echo "Config not found: $CONFIG_FILE"; exit 1; }

# --- Config Parsing -----------------------------------------------------------

parse_yaml() {
  local key="$1"
  grep -E "^[[:space:]]*${key}:" "$CONFIG_FILE" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

PROJECT_NAME="$(parse_yaml 'name')"
REPO_DIR="$(parse_yaml 'repo')"
WORKTREES_DIR="$(parse_yaml 'worktrees')"
DELIBERATE_DIR="${WORKTREES_DIR}/.deliberate"

QUEUE_DIR="${DELIBERATE_DIR}/queue"
DECISIONS_DIR="${DELIBERATE_DIR}/decisions"
STATUS_DIR="${DELIBERATE_DIR}/status"
COMMS_DIR="${DELIBERATE_DIR}/comms"
FOUNDER_INBOX="${COMMS_DIR}/_system/inbox/founder"
STATE_FILE="${STATUS_DIR}/.founder-inbox-state"

POLL_INTERVAL=15
POLL_COUNT=0

# Ensure directories exist
mkdir -p "$FOUNDER_INBOX" "$STATUS_DIR"

# --- Color & Terminal ---------------------------------------------------------

RED="\033[1;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
DIM="\033[2m"
BOLD="\033[1m"
RESET="\033[0m"

# --- State Management --------------------------------------------------------

declare -A SEEN_ITEMS
declare -A COMPLETED_ITEMS
COMPLETED_LOG=()

load_state() {
  SEEN_ITEMS=()
  COMPLETED_ITEMS=()
  COMPLETED_LOG=()

  [[ -f "$STATE_FILE" ]] || return 0

  while IFS=$'\t' read -r status id first_seen last_seen title; do
    [[ "$status" == "#"* ]] && continue
    [[ -z "$status" ]] && continue
    case "$status" in
      ACTIVE)
        SEEN_ITEMS["$id"]="${first_seen}	${last_seen}	${title}"
        ;;
      COMPLETED)
        COMPLETED_ITEMS["$id"]=1
        COMPLETED_LOG+=("${last_seen}	${title}")
        ;;
    esac
  done < "$STATE_FILE"
}

save_state() {
  {
    printf '# Founder Inbox State — do not edit manually\n'
    printf '# Format: STATUS\\tID\\tFIRST_SEEN\\tLAST_SEEN\\tTITLE\n'
    for id in "${!SEEN_ITEMS[@]}"; do
      printf 'ACTIVE\t%s\t%s\n' "$id" "${SEEN_ITEMS[$id]}"
    done
    for entry in "${COMPLETED_LOG[@]}"; do
      local ts="${entry%%	*}"
      local title="${entry#*	}"
      local cid
      cid="$(printf '%s' "$title" | md5 -q 2>/dev/null || printf '%s' "$title" | md5sum 2>/dev/null | cut -d' ' -f1)"
      printf 'COMPLETED\t%s\t%s\t%s\t%s\n' "$cid" "$ts" "$ts" "$title"
    done
  } > "$STATE_FILE"
}

item_id() {
  local source="$1"
  local slug="$2"
  local key="$3"
  echo "${source}-${slug}-${key}" | md5 -q 2>/dev/null || echo "${source}-${slug}-${key}" | md5sum 2>/dev/null | cut -d' ' -f1
}

# --- YAML Helper --------------------------------------------------------------

read_yaml_field() {
  local file="$1"
  local field="$2"
  grep -E "^[[:space:]]*${field}:" "$file" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

# --- Source Scanners ----------------------------------------------------------

declare -a CURRENT_ITEMS
declare -A CURRENT_IDS

scan_queue_yamls() {
  [[ -d "$QUEUE_DIR" ]] || return 0

  for qfile in "$QUEUE_DIR"/*.yaml; do
    [[ -f "$qfile" ]] || continue
    local slug
    slug="$(basename "$qfile" .yaml)"
    local status
    status="$(read_yaml_field "$qfile" 'status')"
    local title
    title="$(read_yaml_field "$qfile" 'title')"
    title="${title:-$slug}"

    local worktree_path="${WORKTREES_DIR}/${slug}"
    local branch=""
    if [[ -d "$worktree_path/.git" ]] || [[ -f "$worktree_path/.git" ]]; then
      branch="$(git -C "$worktree_path" branch --show-current 2>/dev/null || true)"
    fi

    case "$status" in
      BLOCKED)
        local blocker
        blocker="$(read_yaml_field "$qfile" 'blocker')"
        local id
        id="$(item_id "queue" "$slug" "BLOCKED")"
        local details=""
        details+="  ${title} is blocked: ${blocker:-unknown reason}\n"
        details+="  Queue:     ${qfile}\n"
        [[ -d "$worktree_path" ]] && details+="  Worktree:  ${worktree_path}\n"
        [[ -n "$branch" ]] && details+="  Branch:    ${branch}\n"
        details+="  Action:    Resolve the blocker and update status, or set status to QUEUED to retry\n"
        details+="  Respond:   Create ${qfile}.response.md with Action: approve|reject|defer|instruct"
        CURRENT_ITEMS+=("BLOCKED|critical|${slug}|${title}|${id}|${details}")
        CURRENT_IDS["$id"]=1
        ;;
      DEV_COMPLETE|REVIEW_READY)
        local id
        id="$(item_id "queue" "$slug" "REVIEW")"
        local details=""
        details+="  ${title} — development complete, ready for code review\n"
        details+="  Queue:     ${qfile}\n"
        [[ -d "$worktree_path" ]] && details+="  Worktree:  ${worktree_path}\n"
        [[ -n "$branch" ]] && details+="  Branch:    ${branch}\n"
        details+="  Action:    Review the code and advance status"
        CURRENT_ITEMS+=("REVIEW|high|${slug}|${title}|${id}|${details}")
        CURRENT_IDS["$id"]=1
        ;;
      QA_COMPLETE)
        local id
        id="$(item_id "queue" "$slug" "SIGNOFF")"
        local details=""
        details+="  ${title} — QA complete, ready for final sign-off\n"
        details+="  Queue:     ${qfile}\n"
        [[ -d "$worktree_path" ]] && details+="  Worktree:  ${worktree_path}\n"
        [[ -n "$branch" ]] && details+="  Branch:    ${branch}\n"
        details+="  Action:    Final review and approve for release"
        CURRENT_ITEMS+=("REVIEW|high|${slug}|${title}|${id}|${details}")
        CURRENT_IDS["$id"]=1
        ;;
    esac
  done
}

scan_decisions() {
  [[ -d "$DECISIONS_DIR" ]] || return 0

  for dec_file in "$DECISIONS_DIR"/*.md; do
    [[ -f "$dec_file" ]] || continue
    local resolution
    resolution="$(sed -n '/^## Resolution/,/^##/p' "$dec_file" 2>/dev/null | grep -v '^##' | tr -d '[:space:]')"
    [[ -n "$resolution" ]] && continue

    local filename
    filename="$(basename "$dec_file" .md)"
    local subject
    subject="$(head -1 "$dec_file" 2>/dev/null | sed 's/^#* *//')"
    local id
    id="$(item_id "decision" "$filename" "pending")"

    local details=""
    details+="  ${subject:-Pending decision}\n"
    details+="  File:      ${dec_file}\n"
    details+="  Action:    Review and add resolution under ## Resolution\n"
    details+="  Respond:   Create ${dec_file}.response.md with Action: approve|reject|defer|instruct"
    CURRENT_ITEMS+=("DECISION|high|system|${subject:-$filename}|${id}|${details}")
    CURRENT_IDS["$id"]=1
  done
}

scan_founder_messages() {
  [[ -d "$FOUNDER_INBOX" ]] || return 0

  for msg_file in "$FOUNDER_INBOX"/*.md; do
    [[ -f "$msg_file" ]] || continue
    local filename
    filename="$(basename "$msg_file")"
    local urgency
    urgency="$(grep -E '^\- \*\*Urgency\*\*:' "$msg_file" 2>/dev/null | head -1 | sed 's/.*: //')"
    urgency="${urgency:-normal}"
    local msg_subject
    msg_subject="$(head -1 "$msg_file" 2>/dev/null | sed 's/^#* *//')"
    local from
    from="$(grep -E '^\- \*\*From\*\*:' "$msg_file" 2>/dev/null | head -1 | sed 's/.*: //')"

    local id
    id="$(item_id "message" "$filename" "msg")"

    local body
    body="$(sed -n '/^$/,$p' "$msg_file" 2>/dev/null | tail -n +2 | head -20)"

    local details=""
    details+="  From: ${from:-unknown}\n"
    details+="  ${body}\n"
    details+="  File:      ${msg_file}\n"
    details+="  Action:    Review message and acknowledge (delete or move to ack/)\n"
    details+="  Respond:   Create ${msg_file}.response.md with Action: approve|reject|defer|instruct"
    CURRENT_ITEMS+=("MESSAGE|${urgency}|system|${msg_subject:-$filename}|${id}|${details}")
    CURRENT_IDS["$id"]=1
  done
}

scan_orchestrator_heartbeat() {
  local heartbeat="${STATUS_DIR}/orchestrator.md"
  [[ -f "$heartbeat" ]] || return 0

  local last_poll
  last_poll="$(grep -E '^\- \*\*Last Poll\*\*:' "$heartbeat" 2>/dev/null | head -1 | sed 's/.*: //')"
  [[ -z "$last_poll" ]] && return 0

  local last_epoch now_epoch
  last_epoch="$(date -j -f '%Y-%m-%dT%H:%M:%SZ' "$last_poll" '+%s' 2>/dev/null)" || return 0
  now_epoch="$(date '+%s')"
  local age=$(( now_epoch - last_epoch ))

  if (( age > 300 )); then
    local mins=$(( age / 60 ))
    local id
    id="$(item_id "heartbeat" "orchestrator" "stalled")"
    local details=""
    details+="  Orchestrator last polled ${mins}m ago (threshold: 5m)\n"
    details+="  Heartbeat: ${heartbeat}\n"
    details+="  Action:    Check tmux coordination window — orchestrator may have crashed"
    CURRENT_ITEMS+=("STALLED|critical|system|Orchestrator may be stalled (${mins}m)|${id}|${details}")
    CURRENT_IDS["$id"]=1
  fi

  local blocked_count
  blocked_count="$(grep -E '^\- \*\*Blocked\*\*:' "$heartbeat" 2>/dev/null | head -1 | sed 's/.*: //')"
  local active_count
  active_count="$(grep -E '^\- \*\*Active Developers\*\*:' "$heartbeat" 2>/dev/null | head -1 | sed 's/.*: //')"

  if [[ "${blocked_count:-0}" -gt 0 && "${active_count:-0}" -eq 0 ]]; then
    local id
    id="$(item_id "heartbeat" "orchestrator" "all-blocked")"
    local details=""
    details+="  ${blocked_count} initiative(s) blocked, 0 active developers\n"
    details+="  Decisions: ${DECISIONS_DIR}/\n"
    details+="  Action:    Resolve blocking decisions to unblock the pipeline"
    CURRENT_ITEMS+=("STALLED|critical|system|All work stalled — ${blocked_count} blocked, 0 active|${id}|${details}")
    CURRENT_IDS["$id"]=1
  fi
}

scan_founder_responses() {
  [[ -d "$FOUNDER_INBOX" ]] || return 0

  for resp_file in "$FOUNDER_INBOX"/*.response.md; do
    [[ -f "$resp_file" ]] || continue
    local filename
    filename="$(basename "$resp_file")"
    local orig_file="${resp_file%.response.md}.md"
    local action
    action="$(grep -E '^\- \*\*Action\*\*:' "$resp_file" 2>/dev/null | head -1 | sed 's/.*: //')"
    local decision
    decision="$(sed -n '/^## Decision/,/^##/p' "$resp_file" 2>/dev/null | grep -v '^##' | head -5)"

    local orig_name
    orig_name="$(basename "${orig_file}")"

    case "${action,,}" in
      approve)
        local ack_dir="${FOUNDER_INBOX}/ack"
        mkdir -p "$ack_dir"
        local ts
        ts="$(date -u '+%Y%m%d-%H%M%S')"
        [[ -f "$orig_file" ]] && mv "$orig_file" "${ack_dir}/resolved-${ts}-${orig_name}"
        mv "$resp_file" "${ack_dir}/resolved-${ts}-${filename}"
        osascript -e "display notification \"Approved: ${orig_name}\" with title \"Founder Response\" sound name \"Purr\"" 2>/dev/null || true
        ;;
      reject)
        local ack_dir="${FOUNDER_INBOX}/ack"
        mkdir -p "$ack_dir"
        local ts
        ts="$(date -u '+%Y%m%d-%H%M%S')"
        [[ -f "$orig_file" ]] && mv "$orig_file" "${ack_dir}/rejected-${ts}-${orig_name}"
        mv "$resp_file" "${ack_dir}/rejected-${ts}-${filename}"
        osascript -e "display notification \"Rejected: ${orig_name}\" with title \"Founder Response\" sound name \"Basso\"" 2>/dev/null || true
        ;;
      defer)
        osascript -e "display notification \"Deferred: ${orig_name}\" with title \"Founder Response\" sound name \"Tink\"" 2>/dev/null || true
        ;;
      instruct)
        local instruct_dir="${COMMS_DIR}/_system/inbox/orchestrator"
        mkdir -p "$instruct_dir"
        local ts
        ts="$(date -u '+%Y%m%d-%H%M%S')"
        {
          echo "# Founder Instructions"
          echo ""
          echo "- **From**: visionary"
          echo "- **At**: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
          echo "- **Status**: unread"
          echo "- **Re**: ${orig_name}"
          echo ""
          echo "## Instructions"
          echo "$decision"
        } > "${instruct_dir}/${ts}-visionary-to-orchestrator.md"
        local ack_dir="${FOUNDER_INBOX}/ack"
        mkdir -p "$ack_dir"
        [[ -f "$orig_file" ]] && mv "$orig_file" "${ack_dir}/instructed-${ts}-${orig_name}"
        mv "$resp_file" "${ack_dir}/instructed-${ts}-${filename}"
        osascript -e "display notification \"Instructions sent: ${orig_name}\" with title \"Founder Response\" sound name \"Purr\"" 2>/dev/null || true
        ;;
    esac
  done
}

scan_sources() {
  CURRENT_ITEMS=()
  CURRENT_IDS=()
  scan_founder_responses
  scan_queue_yamls
  scan_decisions
  scan_founder_messages
  scan_orchestrator_heartbeat
}

# --- New Item Detection & Notifications --------------------------------------

detect_and_notify_new() {
  local now
  now="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

  for item in "${CURRENT_ITEMS[@]}"; do
    IFS='|' read -r type urgency slug title id details <<< "$item"
    if [[ -z "${SEEN_ITEMS[$id]:-}" ]]; then
      SEEN_ITEMS["$id"]="${now}	${now}	${title}"
      osascript -e "display notification \"${title}\" with title \"Deliberate Agents\" subtitle \"${type}\" sound name \"Ping\"" 2>/dev/null || true
    else
      local parts="${SEEN_ITEMS[$id]}"
      local first_seen="${parts%%	*}"
      SEEN_ITEMS["$id"]="${first_seen}	${now}	${title}"
    fi
  done
}

# --- Completion Detection -----------------------------------------------------

detect_completed() {
  local now
  now="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

  for id in "${!SEEN_ITEMS[@]}"; do
    if [[ -z "${CURRENT_IDS[$id]:-}" ]]; then
      local parts="${SEEN_ITEMS[$id]}"
      local title="${parts##*	}"
      COMPLETED_LOG+=("${now}	${title}")
      COMPLETED_ITEMS["$id"]=1
      unset 'SEEN_ITEMS[$id]'
    fi
  done

  # Keep only last 50 completed items
  if (( ${#COMPLETED_LOG[@]} > 50 )); then
    COMPLETED_LOG=("${COMPLETED_LOG[@]: -50}")
  fi
}

# --- Dashboard Rendering -----------------------------------------------------

urgency_color() {
  case "$1" in
    critical) echo "$RED" ;;
    high)     echo "$YELLOW" ;;
    normal)   echo "$RESET" ;;
    info)     echo "$DIM" ;;
    *)        echo "$RESET" ;;
  esac
}

type_icon() {
  case "$1" in
    BLOCKED)  echo "X" ;;
    DECISION) echo "?" ;;
    MESSAGE)  echo ">" ;;
    REVIEW)   echo "*" ;;
    STALLED)  echo "!" ;;
    *)        echo "-" ;;
  esac
}

render_dashboard() {
  local now
  now="$(date '+%Y-%m-%d %H:%M:%S %Z')"
  local active_count="${#CURRENT_ITEMS[@]}"

  # Clear screen and move cursor to top
  printf '\033[2J\033[H'

  # Header
  printf "${BOLD}${CYAN}"
  printf "======================================================================\n"
  printf "  FOUNDER INBOX — %s\n" "$PROJECT_NAME"
  printf "======================================================================${RESET}\n"
  printf "${DIM}  %s  |  Poll #%d  |  Every %ds${RESET}\n" "$now" "$POLL_COUNT" "$POLL_INTERVAL"
  printf "\n"

  # Action Required
  if (( active_count > 0 )); then
    printf "${BOLD}  ACTION REQUIRED (%d)${RESET}\n" "$active_count"
    printf "  ${DIM}----------------------------------------------------------------------${RESET}\n"

    for item in "${CURRENT_ITEMS[@]}"; do
      IFS='|' read -r type urgency slug title id details <<< "$item"
      local color
      color="$(urgency_color "$urgency")"
      local icon
      icon="$(type_icon "$type")"
      local ts_display=""
      if [[ -n "${SEEN_ITEMS[$id]:-}" ]]; then
        local parts="${SEEN_ITEMS[$id]}"
        local first_seen="${parts%%	*}"
        ts_display="$first_seen"
      fi

      printf "\n"
      printf "  ${color}[%s] %-8s %-40s %s${RESET}\n" "$icon" "$type" "$title" "$ts_display"
      printf "${DIM}"
      echo -e "$details" | while IFS= read -r line; do
        printf "  %s\n" "$line"
      done
      printf "${RESET}"
    done
  else
    printf "${GREEN}${BOLD}  ALL CLEAR${RESET}${GREEN} — nothing needs your attention${RESET}\n"
  fi

  printf "\n"

  # Recently Completed
  local comp_count="${#COMPLETED_LOG[@]}"
  if (( comp_count > 0 )); then
    local show_count=$((comp_count > 10 ? 10 : comp_count))
    printf "  ${DIM}RECENTLY COMPLETED (%d total, showing last %d)${RESET}\n" "$comp_count" "$show_count"
    printf "  ${DIM}----------------------------------------------------------------------${RESET}\n"

    local start_idx=$(( comp_count - show_count ))
    for (( i = comp_count - 1; i >= start_idx; i-- )); do
      local entry="${COMPLETED_LOG[$i]}"
      local ts="${entry%%	*}"
      local ctitle="${entry#*	}"
      printf "  ${DIM}  [done] %s  %s${RESET}\n" "$ts" "$ctitle"
    done
  fi

  printf "\n"
  printf "  ${DIM}Press Ctrl-C to stop  |  Items resolve when their source changes${RESET}\n"
}

# --- Signal Handling ----------------------------------------------------------

cleanup() {
  save_state
  printf '\033[2J\033[H'
  echo "Founder Inbox stopped."
  exit 0
}

trap cleanup SIGTERM SIGINT

# --- Main Loop ----------------------------------------------------------------

load_state

while true; do
  ((POLL_COUNT++)) || true

  scan_sources
  detect_and_notify_new
  detect_completed
  save_state
  render_dashboard

  sleep "$POLL_INTERVAL"
done
