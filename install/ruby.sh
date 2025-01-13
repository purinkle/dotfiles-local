#!/bin/sh

DEFAULT_RUBY_VERSION="3.3.1"

if ! rbenv versions --bare | grep -q "^$DEFAULT_RUBY_VERSION\$"; then
  rbenv install $DEFAULT_RUBY_VERSION
  rbenv global $DEFAULT_RUBY_VERSION
fi
