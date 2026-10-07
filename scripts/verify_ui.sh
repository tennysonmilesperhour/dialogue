#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
xcodegen generate
simulator_id="${DIALOGUE_SIMULATOR_ID:-}"
if [[ -z "$simulator_id" ]]; then
  simulator_id="$(xcrun simctl list devices available -j | python3 -c '
import json, sys
runtimes = json.load(sys.stdin)["devices"]
phones = [d for runtime, devices in runtimes.items() if "iOS" in runtime for d in devices if "iPhone" in d["name"] and d.get("isAvailable")]
preferred = next((d for d in phones if "Pro Max" in d["name"] and "17" in d["name"]), phones[0] if phones else None)
if preferred is None: raise SystemExit("No iPhone simulator installed")
print(preferred["udid"])
')"
fi
result_path="${DIALOGUE_UI_RESULT_PATH:-work/ui-$(date +%Y%m%d-%H%M%S).xcresult}"
xcodebuild test -project Dialogue.xcodeproj -scheme Dialogue -configuration Debug \
  -destination "platform=iOS Simulator,id=$simulator_id" \
  -resultBundlePath "$result_path" -parallel-testing-enabled NO -jobs 2 \
  CODE_SIGNING_ALLOWED=NO
