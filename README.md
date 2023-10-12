# dotfiles

A set of vim, zsh, git, and tmux configuration files.

## Usage

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

From time to time you should pull down any updates to these dotfiles, and run
the following to link any new files and install new vim plugins.

```shell
uatt
```

## Contributing

Thank you, [contributors][]!

## About

dotfiles is maintained by Rob Whittaker.

[contributors]: https://github.com/purinkle/dotfiles/graphs/contributors
