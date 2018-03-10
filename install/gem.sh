if ! is-macos -o ! is-executable brew; then
  echo "Skipped: gem"
  return
fi

PATH=/usr/local/bin:$PATH

brew install rbenv rbenv-default-gems

. "${DOTFILES_DIR}/system/.rbenv"
ln -sfv "$DOTFILES_DIR/etc/rbenv/default-gems" "$(rbenv root)"

CFLAGS=-O3 rbenv install 2.5.0

rbenv global 2.5.0

number_of_cores=$(sysctl -n hw.ncpu)
bundle config --global jobs $((number_of_cores - 1))

# gem install gem-ctags
# gem install awesome_print
# gem install bundler
# gem install highline
# gem install rake
# gem install rubocop
