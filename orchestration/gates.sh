#!/usr/bin/env bash
#
# gates.sh — Ready/Done gate validation for Deliberate_Agents
#
# Sourced by orchestrate.sh. Provides validate_ready_for_* functions that check
# prerequisites before status transitions. Each returns 0 (pass) or 1 (fail).
# On failure, writes a decision file and echoes the reason.
#
# Gate enforcement scales with risk level:
#   low      — log-only, don't block
#   medium   — block on failure, auto-advance on pass
#   high     — block + require peer review sign-off
#   critical — block + require human approval
#
# Dependencies: expects QUEUE_DIR, DELIBERATE_DIR, DECISIONS_DIR, LOG_DIR,
# read_yaml_field(), write_yaml_field(), log_info(), log_warn() from orchestrate.sh

# --- Gate Runner --------------------------------------------------------------

run_gate() {
  local gate_name="$1"
  local initiative_slug="$2"
  local risk_level="${3:-medium}"
  local initiative_file="${QUEUE_DIR}/${initiative_slug}.yaml"

  log_info "Gate check: ${gate_name} for ${initiative_slug} (risk: ${risk_level})"

  local result
  local reason
  reason="$($gate_name "$initiative_slug" 2>&1)"
  result=$?

  if [[ $result -eq 0 ]]; then
    log_info "Gate PASSED: ${gate_name} for ${initiative_slug}"
    record_metric "gate_pass" "$gate_name" "$initiative_slug"
    return 0
  fi

  record_metric "gate_fail" "$gate_name" "$initiative_slug"

  case "$risk_level" in
    low)
      log_warn "Gate FAILED (low risk, continuing): ${gate_name} — ${reason}"
      return 0
      ;;
    medium)
      log_warn "Gate FAILED (blocking): ${gate_name} — ${reason}"
      write_gate_decision "$initiative_slug" "$gate_name" "$reason"
      return 1
      ;;
    high)
      log_warn "Gate FAILED (high risk, blocking + peer review required): ${gate_name} — ${reason}"
      write_gate_decision "$initiative_slug" "$gate_name" "$reason" "Requires peer review before proceeding"
      return 1
      ;;
    critical)
      log_warn "Gate FAILED (critical, human approval required): ${gate_name} — ${reason}"
      write_gate_decision "$initiative_slug" "$gate_name" "$reason" "CRITICAL: Human approval required"
      return 1
      ;;
  esac
}

write_gate_decision() {
  local slug="$1"
  local gate="$2"
  local reason="$3"
  local escalation="${4:-}"
  local decision_file="${DECISIONS_DIR}/gate-${gate}-${slug}.md"

  mkdir -p "$DECISIONS_DIR"
  cat > "$decision_file" <<EOF
# Gate Failure: ${gate}

**Initiative**: ${slug}
**Gate**: ${gate}
**Failed at**: $(date -u '+%Y-%m-%dT%H:%M:%SZ')
**Agent**: orchestrator

## Reason

${reason}

${escalation:+## Escalation

$escalation
}
## Resolution

_(Add your resolution here, then delete this file or move to resolved/)_
EOF
}

record_metric() {
  local event="$1"
  local gate="$2"
  local slug="$3"
  local metrics_dir="${DELIBERATE_DIR}/metrics"

  mkdir -p "$metrics_dir"
  local quality_file="${metrics_dir}/quality.yaml"

  echo "- event: \"${event}\"" >> "$quality_file"
  echo "  gate: \"${gate}\"" >> "$quality_file"
  echo "  initiative: \"${slug}\"" >> "$quality_file"
  echo "  timestamp: \"$(date -u '+%Y-%m-%dT%H:%M:%SZ')\"" >> "$quality_file"
}

# --- Flow Metrics -------------------------------------------------------------

record_flow_metric() {
  local slug="$1"
  local from_status="$2"
  local to_status="$3"
  local metrics_dir="${DELIBERATE_DIR}/metrics"

  mkdir -p "$metrics_dir"
  local flow_file="${metrics_dir}/flow.yaml"

  echo "- initiative: \"${slug}\"" >> "$flow_file"
  echo "  from: \"${from_status}\"" >> "$flow_file"
  echo "  to: \"${to_status}\"" >> "$flow_file"
  echo "  timestamp: \"$(date -u '+%Y-%m-%dT%H:%M:%SZ')\"" >> "$flow_file"
}

record_health_metric() {
  local event="$1"
  local detail="$2"
  local metrics_dir="${DELIBERATE_DIR}/metrics"

  mkdir -p "$metrics_dir"
  local health_file="${metrics_dir}/health.yaml"

  echo "- event: \"${event}\"" >> "$health_file"
  echo "  detail: \"${detail}\"" >> "$health_file"
  echo "  timestamp: \"$(date -u '+%Y-%m-%dT%H:%M:%SZ')\"" >> "$health_file"
}

# --- Gate Validators ----------------------------------------------------------

validate_ready_for_prd() {
  local slug="$1"
  local initiative_file="${QUEUE_DIR}/${slug}.yaml"
  local errors=()

  local one_pager
  one_pager="$(read_yaml_field "$initiative_file" 'one_pager')"
  if [[ -z "$one_pager" ]]; then
    errors+=("one_pager path not set in queue YAML")
  elif [[ ! -f "${WORKTREES_DIR}/${one_pager}" && ! -f "$one_pager" ]]; then
    errors+=("one-pager file not found: ${one_pager}")
  fi

  local status
  status="$(read_yaml_field "$initiative_file" 'status')"
  if [[ "$status" != "QUEUED" && "$status" != "VALIDATED" ]]; then
    errors+=("initiative status is '${status}', expected 'QUEUED' or 'VALIDATED'")
  fi

  if (( ${#errors[@]} > 0 )); then
    printf '%s\n' "${errors[@]}"
    return 1
  fi
  return 0
}

validate_ready_for_validation() {
  local slug="$1"
  local initiative_file="${QUEUE_DIR}/${slug}.yaml"
  local errors=()

  local one_pager
  one_pager="$(read_yaml_field "$initiative_file" 'one_pager')"
  if [[ -z "$one_pager" ]]; then
    errors+=("one_pager path not set in queue YAML")
  elif [[ ! -f "${WORKTREES_DIR}/${one_pager}" && ! -f "$one_pager" ]]; then
    errors+=("one-pager file not found: ${one_pager}")
  fi

  local status
  status="$(read_yaml_field "$initiative_file" 'status')"
  if [[ "$status" != "QUEUED" ]]; then
    errors+=("initiative status is '${status}', expected 'QUEUED'")
  fi

  local requires_validation
  requires_validation="$(read_yaml_field "$initiative_file" 'requires_validation')"
  if [[ "$requires_validation" != "true" ]]; then
    errors+=("requires_validation is not 'true'")
  fi

  if (( ${#errors[@]} > 0 )); then
    printf '%s\n' "${errors[@]}"
    return 1
  fi
  return 0
}

validate_validation_complete() {
  local slug="$1"
  local initiative_file="${QUEUE_DIR}/${slug}.yaml"
  local errors=()

  local validation_evidence
  validation_evidence="$(read_yaml_field "$initiative_file" 'validation_evidence_path')"
  if [[ -z "$validation_evidence" || "$validation_evidence" == "null" ]]; then
    errors+=("validation_evidence_path not set — no evidence of validation work")
  elif [[ ! -f "${WORKTREES_DIR}/${validation_evidence}" && ! -f "$validation_evidence" ]]; then
    errors+=("validation evidence file not found: ${validation_evidence}")
  fi

  if (( ${#errors[@]} > 0 )); then
    printf '%s\n' "${errors[@]}"
    return 1
  fi
  return 0
}

validate_ready_for_arch() {
  local slug="$1"
  local initiative_file="${QUEUE_DIR}/${slug}.yaml"
  local errors=()

  local prd_path
  prd_path="$(read_yaml_field "$initiative_file" 'prd_path')"
  if [[ -z "$prd_path" ]]; then
    errors+=("prd_path not set in queue YAML")
  elif [[ ! -f "${WORKTREES_DIR}/${prd_path}" && ! -f "$prd_path" ]]; then
    errors+=("PRD file not found: ${prd_path}")
  fi

  if (( ${#errors[@]} > 0 )); then
    printf '%s\n' "${errors[@]}"
    return 1
  fi
  return 0
}

validate_ready_for_design() {
  local slug="$1"
  local initiative_file="${QUEUE_DIR}/${slug}.yaml"
  local errors=()

  local arch_path
  arch_path="$(read_yaml_field "$initiative_file" 'architecture_path')"
  local prd_path
  prd_path="$(read_yaml_field "$initiative_file" 'prd_path')"

  if [[ -z "$arch_path" || "$arch_path" == "null" ]]; then
    if [[ -z "$prd_path" ]]; then
      errors+=("neither architecture_path nor prd_path set — nothing for designer to work from")
    fi
  fi

  if (( ${#errors[@]} > 0 )); then
    printf '%s\n' "${errors[@]}"
    return 1
  fi
  return 0
}

validate_ready_for_stories() {
  local slug="$1"
  local initiative_file="${QUEUE_DIR}/${slug}.yaml"
  local errors=()

  local prd_path
  prd_path="$(read_yaml_field "$initiative_file" 'prd_path')"
  if [[ -z "$prd_path" ]]; then
    errors+=("prd_path not set — scrum master needs PRD to decompose stories")
  fi

  if (( ${#errors[@]} > 0 )); then
    printf '%s\n' "${errors[@]}"
    return 1
  fi
  return 0
}

validate_ready_for_dev() {
  local slug="$1"
  local initiative_file="${QUEUE_DIR}/${slug}.yaml"
  local errors=()

  local prd_path
  prd_path="$(read_yaml_field "$initiative_file" 'prd_path')"
  if [[ -z "$prd_path" ]]; then
    errors+=("prd_path not set — can't start dev without a PRD")
  fi

  local task_count
  task_count="$(read_yaml_field "$initiative_file" 'task_count')"
  if [[ -z "$task_count" || "$task_count" == "0" ]]; then
    errors+=("task_count is 0 or unset — no tasks to assign")
  fi

  # Verify at least one worktree exists for this initiative
  if [[ -n "$WORKTREES_DIR" ]]; then
    local has_worktree=false
    for wt in "$WORKTREES_DIR"/*/; do
      [[ -d "$wt" ]] && has_worktree=true && break
    done
    if ! $has_worktree; then
      errors+=("no worktree directories found in ${WORKTREES_DIR}")
    fi
  fi

  if (( ${#errors[@]} > 0 )); then
    printf '%s\n' "${errors[@]}"
    return 1
  fi
  return 0
}

validate_ready_for_review() {
  local slug="$1"
  local initiative_file="${QUEUE_DIR}/${slug}.yaml"
  local errors=()

  local any_incomplete=false
  if [[ -d "$ASSIGNMENTS_DIR" ]]; then
    for f in "$ASSIGNMENTS_DIR"/*.md; do
      [[ -f "$f" ]] || continue
      local init
      init="$(read_md_field "$f" 'Initiative')"
      [[ "$init" == "$slug" ]] || continue
      local status
      status="$(read_md_field "$f" 'Status')"
      if [[ "$status" != "complete" ]]; then
        any_incomplete=true
        errors+=("assignment $(basename "$f") status is '${status}', not 'complete'")
      fi
    done
  fi

  if (( ${#errors[@]} > 0 )); then
    printf '%s\n' "${errors[@]}"
    return 1
  fi
  return 0
}

validate_ready_for_qa() {
  local slug="$1"
  local initiative_file="${QUEUE_DIR}/${slug}.yaml"
  local errors=()

  local review_summary
  review_summary="$(read_yaml_field "$initiative_file" 'review_summary_path')"
  if [[ -z "$review_summary" ]]; then
    errors+=("review_summary_path not set — reviewer hasn't produced a summary")
  fi

  if (( ${#errors[@]} > 0 )); then
    printf '%s\n' "${errors[@]}"
    return 1
  fi
  return 0
}
