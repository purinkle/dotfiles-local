# dotfiles

A set of vim, zsh, git, and tmux configuration files.

## Usage

Clone onto your laptop:

```shell
git clone https://github.com/purinkle/dotfiles.git ~/dotfiles-local
```

We expect you to use these dotfiles in conjunction with [thoughtbot's
dotfiles][]. You will have limited success without that repository.

Once you have cloned the project, run the following command.

```shell
env RCRC=$HOME/dotfiles/rcrc rcup
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
[thoughtbot's dotfiles]: https://github.com/thoughtbot/dotfiles
