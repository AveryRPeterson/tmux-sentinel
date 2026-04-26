#!/bin/bash
set -e

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

case "$ARCH" in
    x86_64)
        SMUG_ARCH="Linux_x86_64"
        SESH_ARCH="Linux_x86_64"
        ;;
    aarch64)
        SMUG_ARCH="Linux_arm64"
        SESH_ARCH="Linux_arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Install smug
if ! command -v smug &> /dev/null; then
    echo "Installing smug for $ARCH..."
    SMUG_VERSION="0.3.3"
    curl -L "https://github.com/ivaaaan/smug/releases/download/v${SMUG_VERSION}/smug_${SMUG_VERSION}_${SMUG_ARCH}.tar.gz" -o smug.tar.gz
    tar -xzf smug.tar.gz smug
    mv smug "$BIN_DIR/"
    rm smug.tar.gz
    chmod +x "$BIN_DIR/smug"
    echo "smug installed to $BIN_DIR"
else
    echo "smug already installed"
fi

# Install sesh
if ! command -v sesh &> /dev/null; then
    echo "Installing sesh for $ARCH..."
    SESH_VERSION="2.26.0"
    # Sesh uses different naming for arm64 in releases sometimes, checking...
    # Based on joshmedeski/sesh releases: sesh_Linux_arm64.tar.gz or sesh_Darwin_arm64.tar.gz
    curl -L "https://github.com/joshmedeski/sesh/releases/download/v${SESH_VERSION}/sesh_${SESH_ARCH}.tar.gz" -o sesh.tar.gz
    tar -xzf sesh.tar.gz sesh
    mv sesh "$BIN_DIR/"
    rm sesh.tar.gz
    chmod +x "$BIN_DIR/sesh"
    echo "sesh installed to $BIN_DIR"
else
    echo "sesh already installed"
fi

# Add BIN_DIR to PATH if not present
SHELL_CONFIG=""
if [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
elif [ -f "$HOME/.config/fish/config.fish" ]; then
    # Fish handles PATH differently, but we'll stick to a simple check
    if ! grep -q "$BIN_DIR" "$HOME/.config/fish/config.fish"; then
        echo "fish_add_path $BIN_DIR" >> "$HOME/.config/fish/config.fish"
    fi
fi

if [ -n "$SHELL_CONFIG" ] && [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    if ! grep -q "$BIN_DIR" "$SHELL_CONFIG"; then
        echo "Adding $BIN_DIR to PATH in $SHELL_CONFIG"
        echo "export PATH=\"\$PATH:$BIN_DIR\"" >> "$SHELL_CONFIG"
    fi
fi

echo "Dependencies installed successfully."
