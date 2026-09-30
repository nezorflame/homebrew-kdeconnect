#!/usr/bin/env bash
set -euo pipefail

CASK="Casks/kdeconnect.rb"
BASE="https://origin.cdn.kde.org/ci-builds/network/kdeconnect-kde/master"

latest_version() {
  local arch="$1"
  curl -fsSL "$BASE/macos-$arch/" \
    | { grep -oE "kdeconnect-kde-master-[0-9]+-macos-clang-$arch\\.dmg" || true; } \
    | sed -E 's/.*-([0-9]+)-macos.*/\1/' \
    | sort -n \
    | tail -1
}

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

updated=false
summary=()

# KDE's CDN keeps only the newest DMG per arch, and the arches publish independently,
# so each one is tracked via its own version_<arch>/sha256_<arch> variable in the cask.
for pair in arm64:arm x86_64:intel; do
  arch="${pair%%:*}"
  var="${pair##*:}"

  current=$(sed -n "s/^  version_$var = \"\([0-9]*\)\".*/\1/p" "$CASK")
  latest=$(latest_version "$arch")
  echo "$arch: current=$current latest=$latest"

  if [[ -z "$latest" ]]; then
    echo "Failed to parse latest $arch version" >&2
    exit 1
  fi
  if [[ "$latest" -le "$current" ]]; then
    continue
  fi

  curl -fsSL -o "$tmpdir/$arch.dmg" "$BASE/macos-$arch/kdeconnect-kde-master-$latest-macos-clang-$arch.dmg"
  sha=$(sha256sum "$tmpdir/$arch.dmg" | awk '{print $1}')

  sed -E -i.bak "s/^(  version_$var = \")[0-9]+(\")/\\1$latest\\2/" "$CASK"
  sed -E -i.bak "s/^(  sha256_$var = \")[0-9a-f]{64}(\")/\\1$sha\\2/" "$CASK"
  rm -f "$CASK.bak"

  updated=true
  summary+=("$arch $latest")
done

if [[ "$updated" != true ]]; then
  echo "No update needed"
  exit 0
fi

new_version=$(IFS=,; echo "${summary[*]}" | sed 's/,/, /g')
echo "Updated: $new_version"
{
  echo "updated=true"
  echo "new_version=$new_version"
} >> "$GITHUB_OUTPUT"
