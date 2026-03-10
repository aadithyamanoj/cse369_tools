#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="$REPO_ROOT/tools/icarus"
ARCH="$(uname -m)"
OS="$(uname -s)"

if [[ "$OS" != "Darwin" ]]; then
    echo "Error: macOS only :("
    exit 1
fi

if [[ "$ARCH" != "arm64" ]]; then
    echo "Error: aarch64 only :("
    exit 1
fi

if [[ -x "$TOOLS_DIR/bin/iverilog" && -x "$TOOLS_DIR/bin/vvp" ]]; then
  echo "Icarus already installed in $TOOLS_DIR"
  exit 0
fi

mkdir -p "$TOOLS_DIR"

#TODO: add web hosted tar ball for precompiled binary, change to course web when approved
TARBALL_URL="https://homes.cs.washington.edu/~amanoj3/icarus-darwin-arm64.tar.gz"
TMP_TAR="$REPO_ROOT/tools/icarus-darwin-arm64.tar.gz"

echo "Downloading Icarus from Website"
curl -L "$TARBALL_URL"

echo "Extracting"
tar -xzf "$TMP_TAR" -o "$TOOLS_DIR"
rm -rf "$TMP_TAR"


if command -v xattr >/dev/null 2>&1; then
  xattr -dr com.apple.quarantine "$TOOLS_DIR" 2>/dev/null || true
fi

chmod +x "$TOOLS_DIR/bin/iverilog" "$TOOLS_DIR/bin/vvp" || true

echo "Setup Complete!"
echo "run make test to confirm"





