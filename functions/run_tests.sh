#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python_bin="$repo_root/functions/venv/bin/python"

if [[ ! -x "$python_bin" ]]; then
  echo "Python virtual environment not found at functions/venv. See functions/README.md."
  exit 1
fi

cd "$repo_root"
CI=1 firebase emulators:exec --only firestore \
  "$python_bin -m pytest -q -ra"
