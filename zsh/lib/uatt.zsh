# Update all the things

uatt() {
  local SEPERATOR="====================="
  brew bundle --global
  brew update
  brew upgrade
  brew cask upgrade
  echo $SEPERATOR
  rcup
  echo "Dotfiles up-to-date"
  echo $SEPERATOR
  asdf update
  asdf plugin-update --all
  echo $SEPERATOR
  mas outdated
  mas upgrade
  echo $SEPERATOR
  waiter 5
}