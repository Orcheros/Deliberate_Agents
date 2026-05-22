#!/usr/bin/env bash
#
# comms.sh — Cross-agent communication for Deliberate_Agents
#
# Sourced by orchestrate.sh and launch-agent.sh. Provides structured
# communication between agents via the filesystem:
#
#   1. Handoff Log    — Orchestrator records every transition with context
#   2. Decision Log   — Agents record significant choices with rationale
#   3. Messages       — Agents leave context notes for downstream agents
#   4. Handoff Receipt — Agents confirm what they received at startup
#
# All communication is append-only, auditable, and scoped per initiative.
#
# Dependencies: expects DELIBERATE_DIR, WORKTREES_DIR from caller.

# --- Directory Setup ----------------------------------------------------------

comms_dir_for() {
  local slug="$1"
  local dir="${DELIBERATE_DIR}/comms/${slug}"
  mkdir -p "$dir/decisions" "$dir/messages"
  echo "$dir"
}

# --- Handoff Log --------------------------------------------------------------
# Called by orchestrate.sh at every status transition.
# Produces an append-only markdown log per initiative.

record_handoff() {
  local slug="$1"
  local from_status="$2"
  local to_status="$3"
  local from_role="$4"
  local to_role="$5"
  local notes="${6:-}"

  local comms_dir
  comms_dir="$(comms_dir_for "$slug")"
  local log_file="${comms_dir}/handoff-log.md"
  local timestamp
  timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

  # Create the log file with header if it doesn't exist
  if [[ ! -f "$log_file" ]]; then
    cat > "$log_file" <<EOF
# Handoff Log: ${slug}

Append-only record of every agent-to-agent transition for this initiative.

---
EOF
  fi

  # Collect artifacts produced by the outgoing agent
  local initiative_file="${QUEUE_DIR}/${slug}.yaml"
  local artifacts=""
  if [[ -f "$initiative_file" ]]; then
    local prd_path arch_path design_path review_path
    prd_path="$(read_yaml_field "$initiative_file" 'prd_path' 2>/dev/null)"
    arch_path="$(read_yaml_field "$initiative_file" 'architecture_path' 2>/dev/null)"
    design_path="$(read_yaml_field "$initiative_file" 'design_brief_path' 2>/dev/null)"
    review_path="$(read_yaml_field "$initiative_file" 'review_summary_path' 2>/dev/null)"
    [[ -n "$prd_path" ]] && artifacts+="  - PRD: ${prd_path}\n"
    [[ -n "$arch_path" && "$arch_path" != "null" ]] && artifacts+="  - Architecture: ${arch_path}\n"
    [[ -n "$design_path" ]] && artifacts+="  - Design: ${design_path}\n"
    [[ -n "$review_path" ]] && artifacts+="  - Review: ${review_path}\n"
  fi

  # Collect any unread messages left by the outgoing agent
  local pending_messages=""
  for msg_file in "$comms_dir"/messages/*-to-"${to_role}".md; do
    [[ -f "$msg_file" ]] || continue
    pending_messages+="  - $(basename "$msg_file")\n"
  done

  # Collect any decisions recorded during this phase
  local recent_decisions=""
  for dec_file in "$comms_dir"/decisions/*-"${from_role}".md; do
    [[ -f "$dec_file" ]] || continue
    recent_decisions+="  - $(basename "$dec_file")\n"
  done

  cat >> "$log_file" <<EOF

## ${timestamp} — ${from_role} → ${to_role}

- **Transition**: ${from_status} → ${to_status}
- **Artifacts available**:
$(echo -e "${artifacts:-  - (none)}")
- **Decisions recorded this phase**:
$(echo -e "${recent_decisions:-  - (none)}")
- **Messages pending for ${to_role}**:
$(echo -e "${pending_messages:-  - (none)}")
${notes:+- **Notes**: ${notes}}

EOF

  log_info "Handoff recorded: ${from_role} → ${to_role} for ${slug}"
}

# --- Decision Log -------------------------------------------------------------
# Called by agents (via bash) when they make a significant choice.
# Usage from agent session:
#   echo "DECISION: chose X over Y because Z" >> .deliberate/comms/{slug}/decisions/{timestamp}-{role}.md

record_decision() {
  local slug="$1"
  local role="$2"
  local title="$3"
  local rationale="$4"
  local alternatives="${5:-}"
  local impact="${6:-}"

  local comms_dir
  comms_dir="$(comms_dir_for "$slug")"
  local timestamp
  timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  local safe_ts
  safe_ts="$(date -u '+%Y%m%d-%H%M%S')"
  local dec_file="${comms_dir}/decisions/${safe_ts}-${role}.md"

  cat > "$dec_file" <<EOF
# Decision: ${title}

- **By**: ${role}
- **At**: ${timestamp}
- **Initiative**: ${slug}

## What was decided

${rationale}

${alternatives:+## Alternatives considered

${alternatives}
}
${impact:+## Impact on downstream agents

${impact}
}
EOF
}

# --- Agent Messages -----------------------------------------------------------
# Agents leave context notes for specific downstream roles.
# These are read by the receiving agent at startup.

send_agent_message() {
  local slug="$1"
  local from_role="$2"
  local to_role="$3"
  local subject="$4"
  local body="$5"

  local comms_dir
  comms_dir="$(comms_dir_for "$slug")"
  local timestamp
  timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  local safe_ts
  safe_ts="$(date -u '+%Y%m%d-%H%M%S')"
  local msg_file="${comms_dir}/messages/${safe_ts}-${from_role}-to-${to_role}.md"

  cat > "$msg_file" <<EOF
# Message: ${subject}

- **From**: ${from_role}
- **To**: ${to_role}
- **At**: ${timestamp}
- **Initiative**: ${slug}

${body}
EOF
}

# --- Handoff Receipt ----------------------------------------------------------
# Called by agents at startup to confirm what they received.
# Validates inputs against expectations and logs the result.

write_handoff_receipt() {
  local slug="$1"
  local role="$2"
  local received_artifacts="$3"
  local missing_items="${4:-}"

  local comms_dir
  comms_dir="$(comms_dir_for "$slug")"
  local timestamp
  timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  local receipt_file="${comms_dir}/receipt-${role}.md"

  local status="complete"
  [[ -n "$missing_items" ]] && status="partial"

  cat > "$receipt_file" <<EOF
# Handoff Receipt: ${role}

- **At**: ${timestamp}
- **Initiative**: ${slug}
- **Status**: ${status}

## Received
${received_artifacts}

${missing_items:+## Missing or incomplete
${missing_items}
}
EOF
}

# --- Read Context for Agent ---------------------------------------------------
# Produces a context block that launch-agent.sh injects into the agent's
# system prompt. Includes: recent decisions, pending messages, handoff summary.

build_comms_context() {
  local slug="$1"
  local role="$2"
  local comms_dir="${DELIBERATE_DIR}/comms/${slug}"

  # No comms yet for this initiative
  if [[ ! -d "$comms_dir" ]]; then
    return
  fi

  local context=""

  # Pending messages addressed to this role
  local msg_count=0
  for msg_file in "$comms_dir"/messages/*-to-"${role}".md; do
    [[ -f "$msg_file" ]] || continue
    ((msg_count++)) || true
  done

  if (( msg_count > 0 )); then
    context+="\n## Messages From Other Agents\n\n"
    context+="You have ${msg_count} message(s) from upstream agents. Read them before starting:\n"
    for msg_file in "$comms_dir"/messages/*-to-"${role}".md; do
      [[ -f "$msg_file" ]] || continue
      context+="- ${msg_file}\n"
    done
    context+="\n"
  fi

  # Recent decisions by upstream agents (last 5)
  local dec_files=()
  for dec_file in "$comms_dir"/decisions/*.md; do
    [[ -f "$dec_file" ]] || continue
    dec_files+=("$dec_file")
  done

  if (( ${#dec_files[@]} > 0 )); then
    context+="\n## Upstream Decisions\n\n"
    context+="These decisions were made by agents who worked on this initiative before you. They may affect your work:\n"
    # Show last 5
    local start=0
    (( ${#dec_files[@]} > 5 )) && start=$(( ${#dec_files[@]} - 5 ))
    for (( i=start; i<${#dec_files[@]}; i++ )); do
      context+="- ${dec_files[$i]}\n"
    done
    context+="\n"
  fi

  # Last handoff entry (what was just handed to you)
  if [[ -f "$comms_dir/handoff-log.md" ]]; then
    context+="\n## Handoff Log\n\n"
    context+="The full handoff history for this initiative is at: ${comms_dir}/handoff-log.md\n"
    context+="Read it to understand how work flowed to you and what artifacts are available.\n\n"
  fi

  # Communication protocol reminder
  context+="\n## Communication Protocol\n\n"
  context+="As you work, record your significant decisions and leave context for downstream agents:\n\n"
  context+="**Record a decision** (when you make a non-obvious choice):\n"
  context+="Write to \`.deliberate/comms/${slug}/decisions/{timestamp}-${role}.md\`:\n"
  context+="\`\`\`markdown\n"
  context+="# Decision: {title}\n"
  context+="- **By**: ${role}\n"
  context+="- **At**: {timestamp}\n"
  context+="## What was decided\n"
  context+="{rationale}\n"
  context+="## Alternatives considered\n"
  context+="{what else you looked at and why you rejected it}\n"
  context+="## Impact on downstream agents\n"
  context+="{what the next agent needs to know about this choice}\n"
  context+="\`\`\`\n\n"
  context+="**Leave a message** for the next agent (when you have context they'll need):\n"
  context+="Write to \`.deliberate/comms/${slug}/messages/{timestamp}-${role}-to-{target-role}.md\`:\n"
  context+="\`\`\`markdown\n"
  context+="# Message: {subject}\n"
  context+="- **From**: ${role}\n"
  context+="- **To**: {target-role}\n"
  context+="{your message — be specific about what they should do differently}\n"
  context+="\`\`\`\n\n"
  context+="**Write a handoff receipt** at the start of your work:\n"
  context+="After reading your inputs, write to \`.deliberate/comms/${slug}/receipt-${role}.md\` confirming what you received and flagging anything missing.\n\n"
  context+="**When to record a decision:**\n"
  context+="- You chose one approach over another\n"
  context+="- You scoped something in or out\n"
  context+="- You deviated from the pattern reference or architecture doc\n"
  context+="- You discovered a constraint that affects downstream work\n"
  context+="- You made an assumption that could be wrong\n\n"
  context+="**When to leave a message:**\n"
  context+="- The next agent needs to know about a gotcha or constraint\n"
  context+="- You found something that affects their work but isn't in the spec\n"
  context+="- You want to flag a risk or concern for a specific role\n"

  echo -e "$context"
}

# =============================================================================
# SYSTEM-LEVEL COMMUNICATION
# =============================================================================
#
# Bidirectional messaging between the Integrator and Orchestrator.
# Uses .deliberate/comms/_system/ (underscore prefix prevents collision with
# initiative slugs which are [a-z0-9-] only).
#
# Directory layout:
#   _system/inbox/integrator/   — messages TO the Integrator
#   _system/inbox/orchestrator/ — messages TO the Orchestrator
#   _system/ack/                — acknowledged messages (audit trail)

system_comms_dir() {
  local dir="${DELIBERATE_DIR}/comms/_system"
  mkdir -p "$dir/inbox/integrator" "$dir/inbox/orchestrator" "$dir/ack"
  echo "$dir"
}

send_system_message() {
  local from_role="$1"
  local to_role="$2"
  local msg_type="$3"
  local subject="$4"
  local body="$5"
  local urgency="${6:-info}"

  local sys_dir
  sys_dir="$(system_comms_dir)"
  local timestamp
  timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  local safe_ts
  safe_ts="$(date -u '+%Y%m%d-%H%M%S')"
  local msg_file="${sys_dir}/inbox/${to_role}/${safe_ts}-${msg_type}.md"

  cat > "$msg_file" <<EOF
# ${msg_type}: ${subject}

- **From**: ${from_role}
- **To**: ${to_role}
- **At**: ${timestamp}
- **Type**: ${msg_type}
- **Urgency**: ${urgency}
- **Status**: unread

${body}
EOF

  log_info "System message sent: ${from_role} → ${to_role} [${msg_type}] ${subject}" 2>/dev/null || true
}

read_system_messages() {
  local role="$1"
  local type_filter="${2:-}"

  local sys_dir
  sys_dir="$(system_comms_dir)"
  local inbox="${sys_dir}/inbox/${role}"

  if [[ ! -d "$inbox" ]]; then
    return
  fi

  if [[ -n "$type_filter" ]]; then
    for msg_file in "$inbox"/*-"${type_filter}".md; do
      [[ -f "$msg_file" ]] || continue
      echo "$msg_file"
    done
  else
    for msg_file in "$inbox"/*.md; do
      [[ -f "$msg_file" ]] || continue
      echo "$msg_file"
    done
  fi
}

ack_system_message() {
  local msg_file="$1"

  if [[ ! -f "$msg_file" ]]; then
    return 1
  fi

  local sys_dir
  sys_dir="$(system_comms_dir)"
  local filename
  filename="$(basename "$msg_file")"
  local ack_ts
  ack_ts="$(date -u '+%Y%m%d-%H%M%S')"

  mv "$msg_file" "${sys_dir}/ack/${ack_ts}-ack-${filename}"
  log_info "System message acknowledged: ${filename}" 2>/dev/null || true
}

count_unread_messages() {
  local role="$1"

  local sys_dir
  sys_dir="$(system_comms_dir)"
  local inbox="${sys_dir}/inbox/${role}"

  if [[ ! -d "$inbox" ]]; then
    echo 0
    return
  fi

  local count=0
  for msg_file in "$inbox"/*.md; do
    [[ -f "$msg_file" ]] || continue
    ((count++)) || true
  done
  echo "$count"
}

build_system_comms_context() {
  local role="$1"
  local sys_dir="${DELIBERATE_DIR}/comms/_system"

  if [[ ! -d "$sys_dir" ]]; then
    return
  fi

  local context=""
  local inbox="${sys_dir}/inbox/${role}"

  # Count and list unread messages
  local msg_count=0
  if [[ -d "$inbox" ]]; then
    for msg_file in "$inbox"/*.md; do
      [[ -f "$msg_file" ]] || continue
      ((msg_count++)) || true
    done
  fi

  if (( msg_count > 0 )); then
    context+="\n## Pending System Messages\n\n"
    context+="You have ${msg_count} unread message(s). **Read and process these before doing anything else.**\n\n"
    for msg_file in "$inbox"/*.md; do
      [[ -f "$msg_file" ]] || continue
      local subject urgency msg_type
      subject="$(grep -E '^# ' "$msg_file" 2>/dev/null | head -1 | sed 's/^# //')"
      urgency="$(grep -E '^\*\*Urgency\*\*:' "$msg_file" 2>/dev/null | head -1 | sed 's/.*: //')"
      msg_type="$(grep -E '^\*\*Type\*\*:' "$msg_file" 2>/dev/null | head -1 | sed 's/.*: //')"
      context+="- **[${urgency:-info}]** ${subject:-$(basename "$msg_file")} — ${msg_file}\n"
    done
    context+="\nAfter processing each message, acknowledge it by moving it to \`${sys_dir}/ack/\`.\n"
  else
    context+="\n## System Messages\n\nNo pending messages.\n"
  fi

  # Communication protocol
  context+="\n## System Communication Protocol\n\n"

  if [[ "$role" == "orchestrator" ]]; then
    context+="**You receive from the Integrator**: directives (do X), priority-change (reorder stack), query (status request)\n"
    context+="**You send to the Integrator**: escalation (needs strategic attention), status-update (periodic summary)\n\n"
    context+="To send a message to the Integrator, write to:\n"
    context+="\`${sys_dir}/inbox/integrator/{timestamp}-{type}.md\`\n\n"
    context+="Use this format:\n"
    context+="\`\`\`markdown\n"
    context+="# escalation: {subject}\n"
    context+="- **From**: orchestrator\n"
    context+="- **To**: integrator\n"
    context+="- **At**: {timestamp}\n"
    context+="- **Type**: escalation\n"
    context+="- **Urgency**: info | warning | critical\n"
    context+="- **Status**: unread\n\n"
    context+="{body — be specific about what needs attention and why}\n"
    context+="\`\`\`\n"
  elif [[ "$role" == "integrator" ]]; then
    context+="**You receive from the Orchestrator**: escalation (something needs strategic attention), status-update (periodic summary)\n"
    context+="**You send to the Orchestrator**: directive (do X), priority-change (reorder stack), query (status request)\n\n"
    context+="To send a directive to the Orchestrator, write to:\n"
    context+="\`${sys_dir}/inbox/orchestrator/{timestamp}-{type}.md\`\n\n"
    context+="Use this format:\n"
    context+="\`\`\`markdown\n"
    context+="# directive: {subject}\n"
    context+="- **From**: integrator\n"
    context+="- **To**: orchestrator\n"
    context+="- **At**: {timestamp}\n"
    context+="- **Type**: directive\n"
    context+="- **Urgency**: info | warning | critical\n"
    context+="- **Status**: unread\n\n"
    context+="{body — be specific about what the Orchestrator should do}\n"
    context+="\`\`\`\n"
  fi

  echo -e "$context"
}
