if ! is-macos -o ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
  return
fi

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap thoughtbot/formulae
brew tap homebrew/bundle
brew tap homebrew/core
brew update
brew upgrade

# Install packages

apps=(
  bash-completion@2
  colordiff
  coreutils
  diff-so-fancy
  dockutil
  ffmpeg
  git
  git-extras
  gnu-sed --with-default-names
  grep --with-default-names
  httpie
  hub
  imagemagick
  jq
  lynx
  mackup
  nano
  openssl
  pandoc
  phantomjs
  postgresql
  psgrep
  rcm
  redis
  rsync
  the_silver_searcher
  tree
  unar
  wget
  youtube-dl
)

brew install "${apps[@]}"

export DOTFILES_BREW_PREFIX_COREUTILS=`brew --prefix coreutils`
set-config "DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_CACHE"

ln -sfv "$DOTFILES_DIR/etc/mackup/.mackup.cfg" ~
