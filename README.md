# tmux-sentinel 🛡️

App-aware tmux session management and layout recovery. Optimized for both desktop Linux and Android (Termux).

## Features
- **Declarative Thawing**: Restore complex layouts via `smug`.
- **App-Aware Hibernation**: Gracefully save state (e.g., Neovim) before closing.
- **Smart Jumping**: Instant project switching via `sesh`.
- **Cross-Platform**: Automatic architecture detection for `x86_64` and `arm64`.

## Installation

```bash
git clone https://github.com/AveryRPeterson/tmux-sentinel.git
cd tmux-sentinel
npm install
```
*The `npm install` step automatically downloads the required `smug` and `sesh` binaries for your architecture.*

## Usage

### Thaw an Environment
Restores a session defined in `configs/<name>.yml`.
```bash
sentinel thaw workstation
```

### Hibernate a Session
Runs pre-save hooks and closes the session.
```bash
sentinel hibernate workstation
```

### Jump to a Project
Quickly switch to a directory.
```bash
sentinel jump ~/Projects/my-app
```

### Sync State
Ensures the current tmux windows match the config.
```bash
sentinel sync workstation
```

## Configuration
Layouts are stored in `configs/` using the [smug](https://github.com/ivaaaan/smug) YAML schema.
