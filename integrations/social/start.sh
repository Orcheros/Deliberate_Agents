#!/usr/bin/env bash
# Unified social platform provider launcher
# Usage:
#   ./start.sh --platform linkedin --test
#   ./start.sh --platform twitter --publish "content here"
#   ./start.sh --platform all --test

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"

# Create/activate venv
if [[ ! -d "$VENV_DIR" ]]; then
  echo "Creating virtual environment..."
  python3 -m venv "$VENV_DIR"
  "$VENV_DIR/bin/pip" install -q -r "$SCRIPT_DIR/requirements.txt"
fi
source "$VENV_DIR/bin/activate"

# Parse args
PLATFORM=""
ACTION=""
CONTENT=""
DRY_RUN=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform) PLATFORM="$2"; shift 2 ;;
    --test) ACTION="test"; shift ;;
    --publish) ACTION="publish"; CONTENT="$2"; shift 2 ;;
    --metrics) ACTION="metrics"; CONTENT="$2"; shift 2 ;;
    --list-posts) ACTION="list"; shift ;;
    --dry-run) DRY_RUN="--dry-run"; shift ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

if [[ -z "$PLATFORM" ]]; then
  echo "Usage: $0 --platform <name> [--test|--publish <content>|--metrics <id>|--list-posts] [--dry-run]"
  echo "Platforms: linkedin, twitter, threads, facebook, instagram, youtube, tiktok, reddit, hackernews, producthunt"
  exit 1
fi

# Run
python3 -c "
import sys
sys.path.insert(0, '$(dirname "$SCRIPT_DIR")')
from social.registry import get_provider

provider = get_provider('$PLATFORM', dry_run=$([[ -n "$DRY_RUN" ]] && echo "True" || echo "False"))

if '$ACTION' == 'test':
    print(f'Testing {provider.platform} provider...')
    try:
        posts = provider.get_my_posts(limit=1)
        print(f'SUCCESS: Connected. Found {len(posts)} recent post(s).')
    except Exception as e:
        print(f'FAILED: {e}', file=sys.stderr)
        sys.exit(1)
elif '$ACTION' == 'publish':
    result = provider.publish_post('$CONTENT')
    print(f'Published: {result}')
elif '$ACTION' == 'metrics':
    result = provider.get_post_metrics('$CONTENT')
    import json
    print(json.dumps(result, indent=2))
elif '$ACTION' == 'list':
    posts = provider.get_my_posts(limit=10)
    for p in posts:
        preview = p['content'][:60].replace(chr(10), ' ')
        print(f'  [{p[\"post_id\"][:8]}] {preview}...')
else:
    print('No action specified. Use --test, --publish, --metrics, or --list-posts')
"
