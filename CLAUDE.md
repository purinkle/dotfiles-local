# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the personal `dotfiles-local` overlay that customizes [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles) and [thoughtbot/laptop](https://github.com/thoughtbot/laptop) for one user. It is intentionally minimal. Its stated purpose (see commit `2581286`) is to act as a **staging ground for changes before upstreaming them** to `thoughtbot/dotfiles`. When something stabilises here, the next move is to send it upstream and then delete the local copy (see commit `df5a7b0` for an example of dropping upstreamed entries).

The thoughtbot working copies live alongside this repo and are added as additional working directories in `.claude/settings.local.json`:

- `~/Developer/thoughtbot/dotfiles`: the shared dotfiles consumed by `rcm`.
- `~/Developer/thoughtbot/laptop`: the `mac` setup script that sources `~/.laptop.local`.
- `~/Developer/basecamp/omakub`, `~/Developer/basecamp/omarchy`: reference Linux setups.

## How this repo is wired in

The repo directory is symlinked: `~/dotfiles-local -> ~/Developer/purinkle/dotfiles`.

`thoughtbot/dotfiles/rcrc` declares `DOTFILES_DIRS="$HOME/dotfiles-local $HOME/dotfiles"`, so when `rcup` runs it symlinks every file here into `$HOME` with a leading dot (e.g. `laptop.local` becomes `~/.laptop.local`). The shared thoughtbot configs then source those `~/.<name>.local` files at the end of their own configs:

- `laptop.local` is sourced by `thoughtbot/laptop/mac` near the end (line ~209). It runs **after** the default `mac` setup completes, so it is the right place to `brew bundle` extra casks/formulae and run `brew upgrade` once everything is installed.
- `zshrc.local` is sourced by `thoughtbot/dotfiles/zshrc` (line 46). It loads **after** `zsh/configs/`, so it is the right place for final overrides like `unsetopt` or `PATH` prepends.
- `client.local` is **not** part of the upstream contract. It is sourced by *this repo's own* `laptop.local` if `~/.client.local` exists, giving a third tier for per-client / work overlays on top of the personal one.

## Commands

```bash
# Re-create/refresh the ~/.<name>.local symlinks after adding or renaming files here.
# Run this from anywhere; rcm reads $HOME/dotfiles-local automatically.
rcup

# Run the full laptop bootstrap (which will source ~/.laptop.local at the end).
~/Developer/thoughtbot/laptop/mac
```

There is no build, test, or lint tooling in this repo. Files are POSIX `sh`; if you reach for shell-checking, run `shellcheck` against the file directly.

## Conventions when adding files

- **Name files after their thoughtbot counterpart with a `.local` suffix** (e.g. `aliases.local`, `gitconfig.local`, `vimrc.local`). `rcup` will symlink them in, and the corresponding shared config is responsible for sourcing them. Without that pairing the file will not be loaded.
- **Before adding a customization, check whether it already belongs upstream.** If the change is generally useful, prefer a PR to `thoughtbot/dotfiles` over keeping it here permanently. That is the explicit purpose of this repo.
- **`brew bundle --file=- <<EOF ... EOF` is the established pattern** for adding casks/formulae from `laptop.local` and `client.local` (rather than maintaining a separate `Brewfile`).
- **Scripts that get sourced (not executed) should still start with `#!/bin/sh`** for shellcheck/editor hints, but must remain POSIX-compatible. `thoughtbot/laptop/mac` itself runs under `/bin/sh`.

## What can go upstream, and what cannot

Two different kinds of thing live here, and only one of them can ever be sent upstream.

- **Values** are the personal answers: the list of apps to install, an email address, the path to a key, the folders that belong to one client. They are the reason a `-local` overlay exists. They stay here for good.
- **Mechanisms** are generic: a new tier of config file, a fix to something the shared setup already promises, a pattern worth ignoring everywhere. These are the upstream candidates.

So "everything here is a candidate for upstreaming" is not true, and aiming for it wastes effort. The working rule is that a mechanism graduates once it has settled, and the values never do.

One test that saves time: if the change can be staged here at all, it probably belongs here. `~/.gitignore` is a symlink to the thoughtbot copy, so a change to it has nowhere local to live and upstream is the only route.

### Client settings are never committed

This repo is public. A settings file for a client names that client, says which folder their code sits in, and often explains which account reaches it. None of that should be published, so it never enters this repo at all.

Instead, `gitconfig.local` carries one committed pointer:

```
[include]
	path = ~/.gitconfig.client
```

Everything about clients lives behind that pointer, outside the repo and outside rcm's reach:

- `~/.gitconfig.client` lists one `includeIf` per client, matching on the folder their work sits in.
- `~/.gitconfig.<client>` holds that client's actual settings, such as the email to commit under or the SSH host alias that reaches their code.

Git ignores an include whose file is missing, so a machine with no client work needs no change and nothing has to be commented out.

Neither file is created by `rcup`, and neither will come back on its own. **Keep copies in 1Password.** `git-hub.config` shows the shape to copy, and stays committed because Hub is a thoughtbot product rather than a client.

## The thoughtbot checkouts are read-only

`~/Developer/thoughtbot/dotfiles` and `~/Developer/thoughtbot/laptop` are mirrors of what is on GitHub. They should never hold an uncommitted change.

Anything you want to change either starts life in this repo, or lives on a named branch that becomes a pull request. An edit left sitting in one of those checkouts is one `git checkout` away from being lost, is invisible to `rcup`, and quietly means your machine depends on something no file records.

The `purinkle` account can push to `thoughtbot/dotfiles` directly, so a fork is not needed. Note that `gh` on this machine is signed in as `thoughtbot-github`, so pull requests are opened by that account while the commits are authored as `rob@thoughtbot.com`.

## How changes are made here

This repo has one author, and still uses pull requests for everything.

- Make the branch first, with `g create-branch <branch-name>`. Never `git checkout -b`. It pushes the branch to GitHub before you start, so the branch exists in one place from the beginning.
- One pull request holds exactly one commit. The pull request title and body match that commit's.
- Commit messages follow [tbaggery][] and the thoughtbot [gitmessage][]: a capitalised title in the imperative of 50 characters or less with no full stop, a blank line, then a body wrapped at 72 columns saying why the change was made, how it solves the problem, and any side effects.
- The title's first word is one of the summary keywords from [git-commit-message][]: Add, Drop, Fix, Bump, Make, Start, Stop, Optimize, Document, Refactor, Reformat, Rearrange, Redraw, Reword, Revise.
- Commit messages, code comments and any prose aim for a Flesch-Kincaid reading grade of 9 or lower. Clear beats short. Explain a term the first time it is used. Measure it rather than guessing.
- No em-dashes anywhere. A hook rejects them.

[tbaggery]: https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[gitmessage]: https://raw.githubusercontent.com/thoughtbot/dotfiles/refs/heads/main/gitmessage
[git-commit-message]: https://raw.githubusercontent.com/joelparkerhenderson/git-commit-message/refs/heads/main/README.md

## Next jobs

- **Finish the buildx setup.** `laptop.local` installs `docker-buildx` and then explains two steps still done by hand. Turn those into code that can run more than once safely.
- **Bring omakub's ideas to macOS.** The two Basecamp repos set up a whole machine, including preferences, themes and a set of commands of their own. The shared `laptop` script deliberately installs tools without setting taste, so `defaults write` settings belong here or in `purinkle/laptop`, not upstream.
