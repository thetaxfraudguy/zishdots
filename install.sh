#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"

header () {
  echo -e "\033[0;35m[DOTFILES]\033[0m - \033[0;34m$1\033[0m"
}

error () {
  echo -e "\t\033[0;31m[ERROR]\033[0m $1"
}

success () {
  echo -e "\t\033[0;32m[OK]\033[0m $1"
}

warn () {
  echo -e "\t\033[0;33m[WARN]\033[0m $1"
}

header "Installing brew packages"
brew bundle install --file="${DOTFILES}/Brewfile"
test -f "$HOME/Brewfile" && brew bundle install

header "Installing ASDF plugins"
asdf_plugins=(
  "packer"
  "terraform"
  "golang"
  "python"
  "nodejs"
)
if command -v asdf >/dev/null 2>&1; then
  for plugin in "${asdf_plugins[@]}"; do
    asdf plugin-add "$plugin" > /dev/null
    success "$plugin"
  done
else
  warn "asdf not found, skipping plugin installation..."
fi

header "Configuring git"
managed=$(git config --get config.source)
if [ "$managed" != "dotfiles" ]; then
  exst_user=$(git config --get user.name)
  exst_email=$(git config --get user.email)
  read -r -p "Set git username ($exst_user): " git_user
  read -r -p "Set git email ($exst_email): " git_email
  git config --global user.name "${git_user:-$exst_user}"
  git config --global user.email "${git_email:-$exst_email}"
  git config --global include.path "$HOME/.gitconfig.local"
  git config --global config.source "dotfiles"
  success "git configured to use dotfiles"
else
  success "git already managed by dotfiles"
fi

header "Symlinking files to home directory"
for f in $(find home -type f -maxdepth 2 | sed 's|^home/||'); do
  if [ -e "${HOME}/${f}" ]; then
    if [ ! -L "${HOME}/${f}" ]; then
      warn "${HOME}/${f} already exists, backing up to ${HOME}/${f}.bak"
      mv "${HOME}/${f}" "${HOME}/${f}.bak"
    fi
  fi
done

stow home/ -v
success "Files linked to home directory"