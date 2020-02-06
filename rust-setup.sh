echo "⬇️ Installing rustlang support"

# Install rustlang tooling
if !(command -v brew &>/dev/null); then
  echo "Please install HomeBrew!";
else 
  brew install rustup;
  rustup-init;
  echo "Rust installed at $(rustc --version)";
  echo "cargo installed at $(cargo --version)";
fi

# Source cargo setup and restart shell
source $HOME/.cargo/env
zsh

# racer for syntax
# rustfmt for formatting
# rustsym for symbol support
# cargo-watch for hot reload
cargo install racer rustfmt rustsym cargo-watch

echo "👏 Rust setup complete!"
