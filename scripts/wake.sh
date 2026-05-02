#!/usr/bin/env bash
#
# wake.sh — Prevent macOS sleep during agent sessions
#
# Two modes:
#   day   — caffeinate wrapper (dies with the process, no sudo)
#   night — pmset overrides for AC power (persistent, requires sudo)
#
# Usage:
#   scripts/wake.sh day <command...>   # wrap a command
#   scripts/wake.sh day                # background caffeinate, print PID
#   scripts/wake.sh night on           # set pmset for overnight runs
#   scripts/wake.sh night off          # restore pmset defaults
#   scripts/wake.sh status             # show current state

set -euo pipefail

MODE="${1:-status}"
shift || true

case "$MODE" in
  day)
    if [[ $# -gt 0 ]]; then
      exec caffeinate -dimsu "$@"
    else
      caffeinate -dimsu &
      CAFF_PID=$!
      echo "$CAFF_PID" > /tmp/deliberate-caffeinate.pid
      echo "caffeinate running (PID $CAFF_PID) — kill it or run: scripts/wake.sh day off"
    fi
    ;;

  night)
    ACTION="${1:-on}"
    if [[ "$ACTION" == "on" ]]; then
      echo "Setting pmset for overnight agent runs (AC power only)..."
      sudo pmset -c sleep 0
      sudo pmset -c displaysleep 0
      sudo pmset -c disksleep 0
      sudo pmset -c powernap 0
      sudo pmset -c hibernatemode 0
      echo "Done. Verify with: pmset -g"
      echo "Revert with: scripts/wake.sh night off"
    elif [[ "$ACTION" == "off" ]]; then
      echo "Restoring default pmset values (AC power)..."
      sudo pmset -c sleep 1
      sudo pmset -c displaysleep 10
      sudo pmset -c disksleep 10
      sudo pmset -c powernap 1
      sudo pmset -c hibernatemode 3
      echo "Done. Verify with: pmset -g"
    else
      echo "Usage: scripts/wake.sh night [on|off]"
      exit 1
    fi
    ;;

  status)
    echo "=== Sleep Prevention Status ==="
    if [[ -f /tmp/deliberate-caffeinate.pid ]]; then
      PID=$(cat /tmp/deliberate-caffeinate.pid)
      if kill -0 "$PID" 2>/dev/null; then
        echo "caffeinate: ACTIVE (PID $PID)"
      else
        echo "caffeinate: NOT RUNNING (stale PID file)"
        rm -f /tmp/deliberate-caffeinate.pid
      fi
    else
      if pgrep -f "caffeinate.*dimsu" > /dev/null 2>&1; then
        echo "caffeinate: ACTIVE (PID $(pgrep -f 'caffeinate.*dimsu' | head -1))"
      else
        echo "caffeinate: NOT RUNNING"
      fi
    fi
    echo ""
    echo "pmset (AC power):"
    pmset -g 2>/dev/null | grep -E "^\s*(sleep|displaysleep|disksleep|powernap|hibernatemode)" || echo "  (could not read pmset)"
    ;;

  *)
    echo "Usage: scripts/wake.sh [day|night|status] [args...]"
    exit 1
    ;;
esac
