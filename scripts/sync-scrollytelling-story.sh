#!/usr/bin/env bash
# Sync the "Who is missing from the map?" data story into this site from its
# canonical source in de-bias/bias-detection.
#
# The story is authored, built and validated in the research repository
# (paper/rsos-debias/scrollytelling/site/) and mirrored here as a static,
# isolated route so the Quarto build never reprocesses or overrides its
# HTML/CSS/JS. This script re-copies that exact file tree from a pinned
# upstream commit so the mirror stays reproducible.
#
# Usage (from the repository root):
#   scripts/sync-scrollytelling-story.sh
#
# To update to a newer research-repo commit, edit UPSTREAM_COMMIT below,
# re-run this script, review the diff, and commit the result.

set -euo pipefail

UPSTREAM_REPO="https://github.com/de-bias/bias-detection.git"
UPSTREAM_COMMIT="ac7621af7d7639987705f41846ec5f1f9f673860"
UPSTREAM_PATH="paper/rsos-debias/scrollytelling/site"
DEST="stories/making-hidden-biases-visible"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

echo "Fetching ${UPSTREAM_REPO} @ ${UPSTREAM_COMMIT}..."
git init --quiet "$tmp_dir"
git -C "$tmp_dir" remote add origin "$UPSTREAM_REPO"
git -C "$tmp_dir" fetch --quiet --depth 1 origin "$UPSTREAM_COMMIT"
git -C "$tmp_dir" checkout --quiet FETCH_HEAD -- "$UPSTREAM_PATH"

echo "Syncing ${UPSTREAM_PATH} -> ${DEST}..."
rm -rf "$DEST"
mkdir -p "$DEST"
cp -R "$tmp_dir/$UPSTREAM_PATH"/. "$DEST"/

echo "Done. Pinned upstream commit: ${UPSTREAM_COMMIT}"
echo "Review the diff, then commit and re-render the site."
