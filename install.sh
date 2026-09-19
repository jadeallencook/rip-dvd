#!/usr/bin/env bash
set -euo pipefail

REPO_RAW_BASE="https://raw.githubusercontent.com/jadeallencook/rip-dvd/main"
INSTALL_DIR="$HOME/.local/bin"
INSTALL_PATH="$INSTALL_DIR/rip-dvd"
SHELL_RC="$HOME/.zshrc"

echo "Installing rip-dvd..."

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required but was not found." >&2
  echo "Install it from https://brew.sh and re-run this installer." >&2
  exit 1
fi

if ! command -v HandBrakeCLI >/dev/null 2>&1; then
  echo "Installing HandBrakeCLI via Homebrew..."
  brew install handbrake
fi

mkdir -p "$INSTALL_DIR"
curl -fsSL "$REPO_RAW_BASE/bin/rip-dvd" -o "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]] && ! grep -qs "$INSTALL_DIR" "$SHELL_RC" 2>/dev/null; then
  {
    echo ""
    echo "# Added by rip-dvd installer"
    echo "export PATH=\"$INSTALL_DIR:\$PATH\""
  } >> "$SHELL_RC"
  echo "Added $INSTALL_DIR to your PATH in $SHELL_RC"
  echo "Restart your shell or run: source $SHELL_RC"
fi

echo ""
echo "rip-dvd installed to $INSTALL_PATH"
echo "Run 'rip-dvd --help' to get started."
