#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
release_tmp="$(mktemp -d "${TMPDIR:-/tmp}/dialogue-release.XXXXXX")"
derived_data="$release_tmp/DerivedData"

cleanup() {
  rm -rf "$release_tmp"
}
trap cleanup EXIT

cd "$repo_root"

xcode_major="$(xcodebuild -version | awk 'NR == 1 {print int($2)}')"
if (( xcode_major < 26 )); then
  echo "App Store uploads now require Xcode 26 or later" >&2
  exit 1
fi

echo "Checking product copy"
python3 scripts/copy_lint.py

echo "Testing DialogueKit"
swift test --package-path DialogueKit

echo "Checking the web build and dependency audit"
npm --prefix web ci
npm --prefix web audit --audit-level=high
npm --prefix web run build

echo "Generating the Xcode project"
xcodegen generate --spec project.yml --project .

echo "Building the App Store configuration with the device SDK"
xcodebuild build \
  -project Dialogue.xcodeproj \
  -scheme Dialogue \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "$derived_data" \
  CODE_SIGNING_ALLOWED=NO \
  >/dev/null

app="$derived_data/Build/Products/Release-iphoneos/Dialogue.app"
if [[ ! -d "$app" ]]; then
  echo "Release build did not produce Dialogue.app" >&2
  exit 1
fi

read_plist() {
  /usr/libexec/PlistBuddy -c "Print :$2" "$1"
}

assert_equal() {
  local actual="$1"
  local expected="$2"
  local label="$3"
  if [[ "$actual" != "$expected" ]]; then
    echo "$label: expected '$expected', found '$actual'" >&2
    exit 1
  fi
}

echo "Inspecting the built application"
assert_equal "$(read_plist "$app/Info.plist" CFBundleIdentifier)" "app.dialogue.ios" "App bundle ID"
assert_equal "$(read_plist "$app/Info.plist" CFBundleShortVersionString)" "1.0.0" "Marketing version"
assert_equal "$(read_plist "$app/Info.plist" CFBundleVersion)" "1" "Build version"
assert_equal "$(read_plist "$app/Info.plist" ITSAppUsesNonExemptEncryption)" "false" "Export compliance"
assert_equal "$(read_plist "$app/Info.plist" UIDeviceFamily:0)" "1" "Supported device family"

if /usr/libexec/PlistBuddy -c 'Print :UIDeviceFamily:1' "$app/Info.plist" >/dev/null 2>&1; then
  echo "The V1 binary must not advertise iPad support" >&2
  exit 1
fi

if [[ ! -f "$app/PrivacyInfo.xcprivacy" ]]; then
  echo "The application privacy manifest is missing from the built bundle" >&2
  exit 1
fi

if [[ ! -f "$app/Assets.car" ]]; then
  echo "The compiled asset catalog is missing from the built bundle" >&2
  exit 1
fi

icon="Dialogue/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"
assert_equal "$(sips -g pixelWidth "$icon" 2>/dev/null | awk '/pixelWidth/ {print $2}')" "1024" "App icon width"
assert_equal "$(sips -g pixelHeight "$icon" 2>/dev/null | awk '/pixelHeight/ {print $2}')" "1024" "App icon height"
assert_equal "$(sips -g hasAlpha "$icon" 2>/dev/null | awk '/hasAlpha/ {print $2}')" "no" "App icon alpha"

extension_names=(DialogueShield DialogueShieldAction DialogueMonitor DialogueReport)
extension_folders=(PlugIns PlugIns PlugIns Extensions)
extension_ids=(
  app.dialogue.ios.shield
  app.dialogue.ios.shieldaction
  app.dialogue.ios.monitor
  app.dialogue.ios.report
)

for extension_index in "${!extension_names[@]}"; do
  extension_name="${extension_names[$extension_index]}"
  extension_folder="${extension_folders[$extension_index]}"
  extension_id="${extension_ids[$extension_index]}"
  extension="$app/$extension_folder/$extension_name.appex"
  if [[ ! -d "$extension" ]]; then
    echo "$extension_name is missing from the application bundle" >&2
    exit 1
  fi
  assert_equal \
    "$(read_plist "$extension/Info.plist" CFBundleIdentifier)" \
    "$extension_id" \
    "$extension_name bundle ID"
  assert_equal \
    "$(read_plist "$extension/Info.plist" ITSAppUsesNonExemptEncryption)" \
    "false" \
    "$extension_name export compliance"
  if [[ ! -f "$extension/PrivacyInfo.xcprivacy" ]]; then
    echo "$extension_name privacy manifest is missing from the built bundle" >&2
    exit 1
  fi
done

for entitlements in Dialogue*/Dialogue*.entitlements; do
  assert_equal \
    "$(read_plist "$entitlements" com.apple.developer.family-controls)" \
    "true" \
    "$entitlements Family Controls entitlement"
  assert_equal \
    "$(read_plist "$entitlements" com.apple.security.application-groups:0)" \
    "group.app.dialogue" \
    "$entitlements App Group"
done

echo "Release verification passed"
