#!/usr/bin/env bash
# Rewrite Formula/resume-cli.rb for a given release tag.
# Usage: update-formula.sh <tag> [formula-path]
# Env: GITHUB_REPOSITORY (default ansidev/resume-cli-ce), ASSET_DIR (use local assets instead of downloading)
set -euo pipefail

tag="${1:?usage: update-formula.sh <tag> [formula-path]}"
formula="${2:-Formula/resume-cli.rb}"
repo="${GITHUB_REPOSITORY:-ansidev/resume-cli-ce}"
version="${tag#v}"

sha256() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | cut -d' ' -f1; else shasum -a 256 "$1" | cut -d' ' -f1; fi
}

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

sums=""
for target in darwin_arm64 darwin_amd64 linux_arm64 linux_amd64; do
  asset="resume-cli_${version}_${target}.tar.gz"
  if [ -n "${ASSET_DIR:-}" ]; then
    cp "${ASSET_DIR}/${asset}" "${workdir}/${asset}"
  else
    curl -fsSL --retry 3 -o "${workdir}/${asset}" \
      "https://github.com/${repo}/releases/download/${tag}/${asset}"
  fi
  sums+="${target} $(sha256 "${workdir}/${asset}")"$'\n'
done

# For each `url` line, swap in the new tag/version and remember its target;
# the sha256 line right after it gets the matching checksum.
SUMS="$sums" awk -v tag="$tag" -v version="$version" -v repo="$repo" '
  BEGIN {
    n = split(ENVIRON["SUMS"], lines, "\n")
    for (i = 1; i <= n; i++) { split(lines[i], kv, " "); if (kv[1] != "") sha[kv[1]] = kv[2] }
  }
  /^[[:space:]]*url "/ {
    match($0, /resume-cli_[^_]+_[a-z]+_[a-z0-9]+\.tar\.gz/)
    asset = substr($0, RSTART, RLENGTH)
    target = asset
    sub(/^resume-cli_[^_]+_/, "", target); sub(/\.tar\.gz$/, "", target)
    match($0, /^[[:space:]]*/)
    indent = substr($0, 1, RLENGTH)
    print indent "url \"https://github.com/" repo "/releases/download/" tag "/resume-cli_" version "_" target ".tar.gz\""
    next
  }
  /^[[:space:]]*sha256 "/ && target != "" {
    if (!(target in sha)) { print "no checksum for " target > "/dev/stderr"; exit 1 }
    match($0, /^[[:space:]]*/)
    print substr($0, 1, RLENGTH) "sha256 \"" sha[target] "\""
    target = ""
    next
  }
  { print }
' "$formula" > "${workdir}/formula.rb"

mv "${workdir}/formula.rb" "$formula"
