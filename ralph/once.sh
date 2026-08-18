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

# Work out the real folder this script lives in, following any shortcuts on
# the way.
#
# rcup puts a shortcut to this script at ~/.ralph/once.sh, but not one to
# prompt.md, because it is told to skip every .md file. So ~/.ralph holds the
# script and nothing else. Asking only for the folder the shortcut sits in
# gives ~/.ralph, where prompt.md is not, and the script dies.
#
# The loop below swaps a shortcut for whatever it points at, over and over,
# until it reaches the real file in this repo. Its neighbour prompt.md is then
# right there. A shortcut can point at a relative path, so anything that is
# not already a full path is joined to the folder the shortcut was in.
source_path="${BASH_SOURCE[0]}"
while [ -L "$source_path" ]; do
  link_dir="$(cd -P "$(dirname "$source_path")" && pwd)"
  source_path="$(readlink "$source_path")"
  case $source_path in
    /*) ;;
    *) source_path="$link_dir/$source_path" ;;
  esac
done
script_dir="$(cd -P "$(dirname "$source_path")" && pwd)"

cd "$repo"

issues=$(cat issues/*.md 2>/dev/null || echo "No issues found")
commits=$(git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")
prompt=$(cat "$script_dir/prompt.md")

claude --permission-mode acceptEdits \
  "Previous commits: $commits Issues: $issues $prompt"
