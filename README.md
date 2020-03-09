# dotfiles

## Install

Clone onto your laptop:

```shell
git clone git://github.com/purinkle/dotfiles.git ~/dotfiles-local
```

Install the dotfiles:

```shell
env RCRC=$HOME/dotfiles-local/rcrc rcup -v
```

Update all the things:

```shell
uatt
```

## Update

From time to time you should pull down any updates to these dotfiles, and run
the following to link any new files and install new vim plugins.

```shell
uatt
```
