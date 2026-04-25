#!/bin/bash
set -e

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

# Install smug
if ! command -v smug &> /dev/null; then
    echo "Installing smug..."
    SMUG_VERSION="0.3.3" # Latest stable as of early 2024
    curl -L "https://github.com/ivaaaan/smug/releases/download/v${SMUG_VERSION}/smug_${SMUG_VERSION}_Linux_x86_64.tar.gz" -o smug.tar.gz
    tar -xzf smug.tar.gz smug
    mv smug "$BIN_DIR/"
    rm smug.tar.gz
    echo "smug installed to $BIN_DIR"
else
    echo "smug already installed"
fi

# Install sesh
if ! command -v sesh &> /dev/null; then
    echo "Installing sesh..."
    SESH_VERSION="2.26.0"
    curl -L "https://github.com/joshmedeski/sesh/releases/download/v${SESH_VERSION}/sesh_Linux_x86_64.tar.gz" -o sesh.tar.gz
    tar -xzf sesh.tar.gz sesh
    mv sesh "$BIN_DIR/"
    rm sesh.tar.gz
    echo "sesh installed to $BIN_DIR"
else
    echo "sesh already installed"
fi

# Add BIN_DIR to PATH if not present
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "Adding $BIN_DIR to PATH in .bashrc"
    echo "export PATH=\"\$PATH:$BIN_DIR\"" >> "$HOME/.bashrc"
    export PATH="$PATH:$BIN_DIR"
fi

echo "Dependencies installed successfully."
