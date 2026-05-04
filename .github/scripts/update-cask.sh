#!/usr/bin/env bash
set -euo pipefail

CASK="Casks/kdeconnect.rb"
BASE="https://origin.cdn.kde.org/ci-builds/network/kdeconnect-kde/master"

extract_version() {
  local arch="$1"
  curl -fsSL "$BASE/macos-$arch/" \
    | grep -oE "kdeconnect-kde-master-[0-9]+-macos-clang-$arch\\.dmg" \
    | sed -E 's/.*-([0-9]+)-macos.*/\1/' \
    | sort -n \
    | tail -1
}

current=$(grep -E '^\s+version "' "$CASK" | sed -E 's/.*"([0-9]+)".*/\1/')
latest_arm=$(extract_version arm64)
latest_intel=$(extract_version x86_64)

echo "current=$current latest_arm=$latest_arm latest_intel=$latest_intel"

if [[ -z "$latest_arm" || -z "$latest_intel" ]]; then
  echo "Failed to parse latest versions" >&2
  exit 1
fi

if [[ "$latest_arm" != "$latest_intel" ]]; then
  echo "Arch versions mismatched; skipping until both builds publish"
  exit 0
fi

new="$latest_arm"

if [[ "$new" -le "$current" ]]; then
  echo "No update needed"
  exit 0
fi

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

curl -fsSL -o "$tmpdir/arm.dmg"   "$BASE/macos-arm64/kdeconnect-kde-master-$new-macos-clang-arm64.dmg"
curl -fsSL -o "$tmpdir/intel.dmg" "$BASE/macos-x86_64/kdeconnect-kde-master-$new-macos-clang-x86_64.dmg"

sha_arm=$(sha256sum "$tmpdir/arm.dmg"   | awk '{print $1}')
sha_intel=$(sha256sum "$tmpdir/intel.dmg" | awk '{print $1}')

sed -E -i.bak "s/^(  version \")[0-9]+(\")/\\1$new\\2/" "$CASK"
sed -E -i.bak "s/^(  sha256 arm:   \")[0-9a-f]{64}(\",)/\\1$sha_arm\\2/" "$CASK"
sed -E -i.bak "s/^(         intel: \")[0-9a-f]{64}(\")/\\1$sha_intel\\2/" "$CASK"
rm "$CASK.bak"

echo "Updated to $new"
{
  echo "updated=true"
  echo "new_version=$new"
} >> "$GITHUB_OUTPUT"
