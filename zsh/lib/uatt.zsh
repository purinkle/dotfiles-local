# Update all the things

uatt() {
  local SEPERATOR="====================="
  brew bundle --global
  brew bundle --global cleanup --force
  brew update
  brew upgrade
  brew upgrade --cask
  echo $SEPERATOR
  rcup
  echo "Dotfiles up-to-date"
  echo $SEPERATOR
  asdf plugin-update --all
  echo $SEPERATOR
  waiter 5
}
