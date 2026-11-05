#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
instance_id="$(printf '%s' "$repo_root" | shasum | cut -c 1-12)"
pid_file="${TMPDIR:-/tmp}/invite-emulators-${instance_id}.pid"
log_file="${TMPDIR:-/tmp}/invite-emulators-${instance_id}.log"

is_listening() {
  lsof -nP -iTCP:"$1" -sTCP:LISTEN -t 2>/dev/null | /usr/bin/grep -q .
}

is_ready() {
  is_listening 9099 && is_listening 5001 && is_listening 8080
}

if [[ "${1:-start}" == "stop" ]]; then
  if [[ -f "$pid_file" ]]; then
    kill "$(cat "$pid_file")" 2>/dev/null || true
    rm -f "$pid_file"
  fi
  exit 0
fi

if is_ready; then
  echo "Invite Firebase Emulators are already running."
  exit 0
fi

if [[ ! -x "$repo_root/functions/.venv/bin/python" ]]; then
  echo "Missing functions/.venv. Follow functions/README.md setup." >&2
  exit 1
fi

export PATH="$HOME/.npm-global/bin:/opt/homebrew/opt/openjdk@21/bin:$PATH"
if ! command -v firebase >/dev/null || ! command -v java >/dev/null; then
  echo "Firebase CLI or Java is missing. Follow functions/README.md setup." >&2
  exit 1
fi

missing=()
if ! is_listening 9099; then missing+=(auth); fi
if ! is_listening 5001; then missing+=(functions); fi
if is_listening 8080; then
  # Functions를 별도로 시작해도 Admin SDK가 기존 Firestore Emulator를 사용하도록 한다.
  export FIRESTORE_EMULATOR_HOST="127.0.0.1:8080"
else
  missing+=(firestore)
fi
emulators="$(IFS=,; echo "${missing[*]}")"

cd "$repo_root"
nohup firebase emulators:start --only "$emulators" >"$log_file" 2>&1 </dev/null &
echo "$!" >"$pid_file"

for _ in {1..90}; do
  if is_ready; then
    echo "Invite Firebase Emulators ready (log: $log_file)."
    exit 0
  fi
  if ! kill -0 "$(cat "$pid_file")" 2>/dev/null; then
    cat "$log_file" >&2
    exit 1
  fi
  sleep 1
done

echo "Invite Firebase Emulators did not start within 90 seconds. Log: $log_file" >&2
tail -40 "$log_file" >&2
exit 1
