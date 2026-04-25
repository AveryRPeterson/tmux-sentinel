---
name: tmux-sentinel
description: Declarative tmux session management, app-aware recovery, and native persistence. Uses smug for layouts and sesh for dynamic switching.
---

# tmux Sentinel Skill

This skill provides high-level, declarative management of `tmux` environments, ensuring complex layouts can be reliably "thawed" (restored) and "hibernated" (gracefully saved) with application-aware state.

## Core Capabilities

1.  **Declarative Thawing**: Bring up complex multi-window/pane layouts defined in YAML.
2.  **App-Aware Hibernation**: Gracefully shut down sessions while triggering application-specific save hooks (e.g., Neovim session saving).
3.  **Dynamic Jumping**: Instantly create or attach to sessions based on directory paths using `sesh`.
4.  **State Sync**: Detect and resolve drift between the current tmux state and the declarative configuration.

## Workflow

### 1. Thaw an Environment
Restore a complex environment from a configuration file.
- `node scripts/sentinel.cjs thaw <config-name>`

### 2. Hibernate a Session
Save application state and close the session.
- `node scripts/sentinel.cjs hibernate <session-name>`

### 3. Jump to a Project
Quickly switch to a project session.
- `node scripts/sentinel.cjs jump <path>`

### 4. Sync State
Ensure the current tmux windows/panes match the declarative config.
- `node scripts/sentinel.cjs sync <config-name>`

## Integration with tmux-interaction
- Use **tmux-sentinel** for macro-level environment setup and recovery.
- Use **tmux-interaction** for micro-level surgical tasks and TUI interaction within the established environment.

## App-Aware Recovery
The sentinel automatically detects running applications and triggers their native save mechanisms:
- **Neovim**: Sends `:SessionSave` or equivalent keys.
- **Shell**: Ensures history is persisted.

## Configuration
Declarative layouts are stored in `configs/*.yml` and follow the `smug` configuration schema.
