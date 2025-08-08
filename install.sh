#!/bin/bash

set -e

# Check if go is installed
if ! command -v go &> /dev/null
then
    echo "Go is not installed. Please install Go to continue."
    exit 1
fi

echo "Building binary..."
make build

# Determine installation path
INSTALL_DIR=""
if [ -n "$GOPATH" ] && [ -d "$GOPATH/bin" ]; then
    INSTALL_DIR="$GOPATH/bin"
elif [ -d "$HOME/go/bin" ]; then
    INSTALL_DIR="$HOME/go/bin"
else
    OS=$(uname -s)
    if [ "$OS" == "Linux" ]; then
        INSTALL_DIR="$HOME/.local/bin"
    elif [ "$OS" == "Darwin" ]; then
        INSTALL_DIR="/usr/local/bin"
    else
        echo "Unsupported OS: $OS"
        exit 1
    fi
fi

echo "Creating installation directory if it doesn't exist: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# Check if the binary already exists in the installation directory
if [ -f "$INSTALL_DIR/mcp-memory-libsql-go" ]; then
    echo "Binary already exists in $INSTALL_DIR, removing it before installing."
    # Remove the binary
    rm "$INSTALL_DIR/mcp-memory-libsql-go"
fi

echo "Installing binary to $INSTALL_DIR"
mv $1 "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/mcp-memory-libsql-go"

echo "Installation complete."
echo
echo "Please ensure that '$INSTALL_DIR' is in your PATH."
echo "You can add it to your shell's configuration file (e.g., ~/.bashrc, ~/.zshrc) with:"
echo "export PATH=\"\$PATH:$INSTALL_DIR\""
