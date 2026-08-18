#!/bin/bash
set -euo pipefail

# Run one turn of the Ralph loop, where Claude picks a job and does it.
#
# Usage: once.sh <path-to-the-project>
#
# This script is kept here, in dotfiles, rather than inside the project it
# works on. That way the loop is saved and shared once instead of being
# copied into every project, and a project's own history stays free of it.
#
# It moves into the project given as the first argument, so the notes in
# issues/ and the recent commits it reads come from that project. It finds
# prompt.md by looking next to itself, which keeps working wherever it is
# run from.

repo="${1:?usage: once.sh <target-repo-dir>}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$repo"

issues=$(cat issues/*.md 2>/dev/null || echo "No issues found")
commits=$(git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")
prompt=$(cat "$script_dir/prompt.md")

claude --permission-mode acceptEdits \
  "Previous commits: $commits Issues: $issues $prompt"
