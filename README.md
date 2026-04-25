# tmux Sentinel

Declarative tmux session management, app-aware recovery, and native persistence for Gemini CLI.

## Overview

`tmux-sentinel` provides a high-level orchestration layer for tmux environments. It uses `smug` for declarative layouts and `sesh` for dynamic session jumping.

## Features

- **Declarative Thawing**: Restore complex layouts from YAML files.
- **App-Aware Hibernation**: Gracefully save application state (e.g., Neovim) before closing sessions.
- **Dynamic Project Jumping**: Instantly switch to any project directory with optimized session management.
- **Drift Detection**: Sync current tmux state with declarative configs.

## Installation

1. Clone this repository.
2. Run `bash scripts/install_deps.sh` to install `smug` and `sesh`.
3. Add the skill to your Gemini CLI configuration.

## Usage

### Thaw an environment
```bash
node scripts/sentinel.cjs thaw <config-name>
```

### Hibernate a session
```bash
node scripts/sentinel.cjs hibernate <session-name>
```

### Jump to a project
```bash
node scripts/sentinel.cjs jump <path>
```

## Configuration

Place your `smug` configuration files in the `configs/` directory.

## App-Aware Hooks

Custom hooks for saving state are located in `scripts/hooks/`.
- `pre_hibernate.sh`: Scans for running processes and sends save commands.
