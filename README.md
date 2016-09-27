purinkle dotfiles
===============

I use [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles) and
purinkle/dotfiles together using [the `*.local` convention][dot-local].

[dot-local]:
http://robots.thoughtbot.com/manage-team-and-personal-dotfiles-together-with-rcm

Requirements
------------

Set zsh as my login shell.

    chsh -s /bin/zsh

Install [rcm](https://github.com/mike-burns/rcm).

    brew tap thoughtbot/formulae
    brew install rcm

Install
-------

Clone onto my laptop:

    git clone git://github.com/purinkle/dotfiles.git

Install:

    env RCRC=$HOME/purinkle/dotfiles/rcrc rcup

This will create symlinks for config files in my home directory.

I can safely run `rcup` multiple times to update.

What's in it?
-------------

[vim](http://www.vim.org/) configuration:

* [Base16 colour scheme](https://github.com/chriskempson/base16-vim)

[git](http://git-scm.com/) configuration:

* My name and email.
