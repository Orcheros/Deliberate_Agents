#!/usr/bin/env bash
# Video render provider launcher
# Usage:
#   ./start.sh --provider heygen --test
#   ./start.sh --provider runway --render script.json

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"

if [[ ! -d "$VENV_DIR" ]]; then
  echo "Creating virtual environment..."
  python3 -m venv "$VENV_DIR"
  "$VENV_DIR/bin/pip" install -q -r "$SCRIPT_DIR/requirements.txt"
fi
source "$VENV_DIR/bin/activate"

PROVIDER=""
ACTION=""
INPUT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --provider) PROVIDER="$2"; shift 2 ;;
    --test) ACTION="test"; shift ;;
    --render) ACTION="render"; INPUT="$2"; shift 2 ;;
    --status) ACTION="status"; INPUT="$2"; shift 2 ;;
    --download) ACTION="download"; INPUT="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

if [[ -z "$PROVIDER" ]]; then
  echo "Usage: $0 --provider <heygen|runway|manual> [--test|--render <script.json>|--status <job_id>|--download <job_id>]"
  exit 1
fi

python3 -c "
import sys, json
sys.path.insert(0, '$(dirname "$SCRIPT_DIR")')
from video.registry import get_video_provider

provider = get_video_provider('$PROVIDER')
print(f'Provider: {provider.provider_name}')

if '$ACTION' == 'test':
    print(f'SUCCESS: {provider.provider_name} provider initialized')
elif '$ACTION' == 'render':
    with open('$INPUT') as f:
        script = json.load(f)
    result = provider.render_video(script, style='avatar')
    print(json.dumps(result, indent=2))
elif '$ACTION' == 'status':
    result = provider.check_status('$INPUT')
    print(json.dumps(result, indent=2))
elif '$ACTION' == 'download':
    path = provider.download('$INPUT', './output.mp4')
    print(f'Downloaded to: {path}')
else:
    print('No action specified.')
"
