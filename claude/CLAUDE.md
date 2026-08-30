# CLAUDE.md

These are Rob's standing preferences, and they apply in every repository unless
that repository says otherwise. A project's own `CLAUDE.md` wins where the two
disagree.

Version controlled at `~/dotfiles-local/claude/CLAUDE.md` and linked to
`~/.claude/CLAUDE.md` by hand, because `~/.rcrc` sets `EXCLUDES="*.md"` and so
`rcup` will never link a Markdown file. `ralph/prompt.md` has the same problem.

## Branches, commits and pull requests

- Make the branch first, with `g create-branch <branch-name>`, before changing
  anything. Never `git checkout -b`. It pushes the branch before you start, so
  the branch exists in one place from the beginning.
- One pull request holds exactly one commit. The pull request title and body
  match that commit's. The pull request body does not need the 72 column wrap.
- Never stack a pull request on another branch. Deleting the base makes GitHub
  mark the child Closed rather than Merged.
- Merge locally, never with the GitHub button:
  `g co <branch> && g merge-branch && g push && g delete-branch <branch>`.
- Merging the second of two open branches needs a rebase first. Git is set to
  `merge.ff only`, so `g merge-branch` refuses once main has moved under the
  branch. Run `git rebase main` and `git push --force-with-lease`, then the
  line above. No stacking makes this the normal case, not the odd one.
- `g delete-branch <branch>` removes the branch locally and on the remote.
  `git branch -d` does half the job and leaves the remote branch behind.

## Commit messages

Follow [tbaggery][] and the thoughtbot [gitmessage][]: a capitalised title in
the imperative of 50 characters or less with no full stop, a blank line, then a
body wrapped at 72 columns saying why the change was made, how it solves the
problem, and any side effects.

The title's first word is one of the summary keywords from
[git-commit-message][]: Add, Drop, Fix, Bump, Make, Start, Stop, Optimize,
Document, Refactor, Reformat, Rearrange, Redraw, Reword, Revise.

Do not list the files changed. `git show --stat` already prints that, and the
list goes stale the moment anyone rebases. Do not put blockers or notes for the
next session in the message either; those belong in the issue or card the work
came from.

## Prose

- Commit messages, code comments and any prose aim for a Flesch-Kincaid reading
  grade of 9 or lower. Clear beats short. Explain a term the first time it is
  used.
- **Measure the grade, do not guess it.** `readability` scores a file or stdin
  and exits non-zero above grade 9.
- No em-dashes anywhere. A hook rejects them on `Write` and `Edit`.

## Claims

State what you checked and how. If something is taken from a memory, a note or
a previous session rather than verified now, say so, and prefer verifying it.
A memory records what was true when it was written, not what is true today.

Do not put a number, a version, a file path or a security claim into a commit
message, a pull request or a message to a client without checking it first.

[tbaggery]: https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[gitmessage]: https://raw.githubusercontent.com/thoughtbot/dotfiles/refs/heads/main/gitmessage
[git-commit-message]: https://raw.githubusercontent.com/joelparkerhenderson/git-commit-message/refs/heads/main/README.md
