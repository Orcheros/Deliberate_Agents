#!/usr/bin/env bash
#
# sync-initiatives.sh — Reconcile initiative directories with STATUS.yaml state
#
# Scans all initiative directories across lifecycle directories, reads each
# initiative's STATUS.yaml, and moves initiatives whose declared state doesn't
# match their current directory. Also regenerates TRACKER.md from STATUS.yaml
# files.
#
# Designed to be called by the orchestrator on each poll cycle, or manually.
#
# Usage: sync-initiatives.sh <config-file> [options]
#
# Options:
#   --dry-run       Show what would change without moving anything
#   --no-tracker    Skip TRACKER.md regeneration
#   --quiet         Suppress non-essential output
#   -h, --help      Show this help

set -euo pipefail

CONFIG_FILE=""
DRY_RUN=false
NO_TRACKER=false
QUIET=false

# --- Argument Parsing ---------------------------------------------------------

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)      DRY_RUN=true; shift ;;
    --no-tracker)   NO_TRACKER=true; shift ;;
    --quiet)        QUIET=true; shift ;;
    -h|--help)
      sed -n '2,/^$/p' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    -*)
      echo "Unknown option: $1"; exit 1
      ;;
    *)
      if [[ -z "$CONFIG_FILE" ]]; then
        CONFIG_FILE="$1"; shift
      else
        echo "ERROR: Unexpected argument: $1"; exit 1
      fi
      ;;
  esac
done

[[ -n "$CONFIG_FILE" ]] || { echo "ERROR: Config file required. Usage: sync-initiatives.sh <config-file>"; exit 1; }
[[ -f "$CONFIG_FILE" ]] || { echo "ERROR: Config file not found: $CONFIG_FILE"; exit 1; }

# --- Parse Config -------------------------------------------------------------

parse_yaml() {
  local key="$1"
  grep -E "^\s*${key}:" "$CONFIG_FILE" | head -1 | sed 's/[^:]*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

REPO_DIR="$(parse_yaml 'repo')"
INITIATIVES_PATH="$(parse_yaml 'initiatives_path')"
INITIATIVES_DIR="${REPO_DIR}/${INITIATIVES_PATH}"

[[ -d "$INITIATIVES_DIR" ]] || { echo "ERROR: Initiatives directory not found: $INITIATIVES_DIR"; exit 1; }

log() {
  [[ "$QUIET" == true ]] && return
  echo "$@"
}

# --- Standard Lifecycle Directories -------------------------------------------

LIFECYCLE_DIRS=("backlog" "specified" "in-progress" "shipped" "retired")

# Ensure all lifecycle directories exist
for dir in "${LIFECYCLE_DIRS[@]}"; do
  mkdir -p "${INITIATIVES_DIR}/${dir}"
done

# --- Read STATUS.yaml from a directory ----------------------------------------

read_status_field() {
  local file="$1"
  local field="$2"
  grep -E "^\s*${field}:" "$file" 2>/dev/null | head -1 | sed 's/[^:]*:[[:space:]]*//' | tr -d '"' | tr -d "'"
}

# --- Scan and Reconcile -------------------------------------------------------

MOVED=0
ERRORS=0

# Scan all lifecycle directories for initiatives with mismatched state
for lifecycle_dir in "${LIFECYCLE_DIRS[@]}"; do
  dir_path="${INITIATIVES_DIR}/${lifecycle_dir}"
  [[ -d "$dir_path" ]] || continue

  for init_dir in "$dir_path"/*/; do
    [[ -d "$init_dir" ]] || continue

    status_file="${init_dir}STATUS.yaml"
    [[ -f "$status_file" ]] || continue

    declared_state="$(read_status_field "$status_file" 'state')"
    [[ -n "$declared_state" ]] || continue

    # Check if the declared state matches the current directory
    if [[ "$declared_state" != "$lifecycle_dir" ]]; then
      init_name="$(basename "$init_dir")"
      target_dir="${INITIATIVES_DIR}/${declared_state}"

      # Validate target is a known lifecycle directory
      valid_target=false
      for valid_dir in "${LIFECYCLE_DIRS[@]}"; do
        if [[ "$declared_state" == "$valid_dir" ]]; then
          valid_target=true
          break
        fi
      done

      if [[ "$valid_target" != true ]]; then
        log "  WARNING: Invalid state '${declared_state}' in ${init_name}/STATUS.yaml — skipping"
        ((ERRORS++))
        continue
      fi

      # Check for name collision in target
      if [[ -d "${target_dir}/${init_name}" ]]; then
        log "  WARNING: ${init_name} already exists in ${declared_state}/ — skipping"
        ((ERRORS++))
        continue
      fi

      log "  Moving: ${lifecycle_dir}/${init_name} → ${declared_state}/${init_name}"

      if [[ "$DRY_RUN" != true ]]; then
        mkdir -p "$target_dir"
        mv "$init_dir" "${target_dir}/${init_name}"
      fi

      ((MOVED++))
    fi
  done
done

# Also check top-level initiatives (not yet in a lifecycle directory)
for init_dir in "$INITIATIVES_DIR"/*/; do
  [[ -d "$init_dir" ]] || continue
  init_name="$(basename "$init_dir")"

  # Skip lifecycle directories themselves
  case "$init_name" in
    backlog|specified|in-progress|shipped|retired) continue ;;
    .*|"Initiative Templates") continue ;;
  esac

  status_file="${init_dir}STATUS.yaml"
  [[ -f "$status_file" ]] || continue

  declared_state="$(read_status_field "$status_file" 'state')"
  [[ -n "$declared_state" ]] || continue

  # Validate target
  valid_target=false
  for valid_dir in "${LIFECYCLE_DIRS[@]}"; do
    if [[ "$declared_state" == "$valid_dir" ]]; then
      valid_target=true
      break
    fi
  done

  if [[ "$valid_target" != true ]]; then
    log "  WARNING: Invalid state '${declared_state}' in ${init_name}/STATUS.yaml — skipping"
    ((ERRORS++))
    continue
  fi

  target_dir="${INITIATIVES_DIR}/${declared_state}"

  if [[ -d "${target_dir}/${init_name}" ]]; then
    log "  WARNING: ${init_name} already exists in ${declared_state}/ — skipping"
    ((ERRORS++))
    continue
  fi

  log "  Moving: ${init_name} → ${declared_state}/${init_name}"

  if [[ "$DRY_RUN" != true ]]; then
    mkdir -p "$target_dir"
    mv "$init_dir" "${target_dir}/${init_name}"
  fi

  ((MOVED++))
done

if [[ $MOVED -gt 0 ]]; then
  log "Synced: ${MOVED} initiative(s) moved"
elif [[ "$QUIET" != true ]]; then
  log "All initiatives in correct directories"
fi

if [[ $ERRORS -gt 0 ]]; then
  log "Warnings: ${ERRORS} issue(s) encountered"
fi

# --- Regenerate TRACKER.md ----------------------------------------------------

if [[ "$NO_TRACKER" == true ]]; then
  exit 0
fi

TRACKER_FILE="${INITIATIVES_DIR}/TRACKER.md"

generate_tracker() {
  local tracker_tmp
  tracker_tmp="$(mktemp)"

  cat > "$tracker_tmp" <<'HEADER'
# Initiative Tracker

> Auto-generated from STATUS.yaml files. Do not edit manually.
> Regenerated by: `sync-initiatives.sh`

HEADER

  for lifecycle_dir in "${LIFECYCLE_DIRS[@]}"; do
    dir_path="${INITIATIVES_DIR}/${lifecycle_dir}"
    [[ -d "$dir_path" ]] || continue

    # Count initiatives in this directory
    local count=0
    local entries=""
    for init_dir in "$dir_path"/*/; do
      [[ -d "$init_dir" ]] || continue
      local init_name
      init_name="$(basename "$init_dir")"
      local status_file="${init_dir}STATUS.yaml"

      local id="" title="" updated_at="" reason=""
      if [[ -f "$status_file" ]]; then
        id="$(read_status_field "$status_file" 'id')"
        title="$(read_status_field "$status_file" 'title')"
        updated_at="$(read_status_field "$status_file" 'updated_at')"
        reason="$(read_status_field "$status_file" 'reason')"
      fi

      id="${id:-$init_name}"
      title="${title:-$init_name}"
      updated_at="${updated_at:--}"
      reason="${reason:--}"

      entries+="| ${id} | ${title} | ${updated_at} | ${reason} |\n"
      ((count++))
    done

    # Write section header
    local display_name
    display_name="$(echo "$lifecycle_dir" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')"

    echo "## ${display_name} (${count})" >> "$tracker_tmp"
    echo "" >> "$tracker_tmp"

    if [[ $count -eq 0 ]]; then
      echo "_No initiatives._" >> "$tracker_tmp"
    else
      echo "| ID | Title | Updated | Status |" >> "$tracker_tmp"
      echo "|---|---|---|---|" >> "$tracker_tmp"
      echo -e "$entries" >> "$tracker_tmp"
    fi

    echo "" >> "$tracker_tmp"
  done

  # Add generation timestamp
  echo "---" >> "$tracker_tmp"
  echo "_Last synced: $(date -u '+%Y-%m-%d %H:%M:%S UTC')_" >> "$tracker_tmp"

  mv "$tracker_tmp" "$TRACKER_FILE"
}

if [[ "$DRY_RUN" != true ]]; then
  generate_tracker
  log "Regenerated: ${TRACKER_FILE}"
fi
