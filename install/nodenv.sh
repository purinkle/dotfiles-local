#!/bin/sh

mkdir -p "$(nodenv root)"/plugins

if [ ! -d "$(nodenv root)"/plugins/nodenv-aliases ]; then
  git clone https://github.com/nodenv/nodenv-aliases.git \
    "$(nodenv root)"/plugins/nodenv-aliases
fi

if ! nodenv versions --bare | grep -q "20.11.1"; then
  nodenv install 20.11.1
  nodenv global 20.11.1
fi
