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

## Agent-Specific Guidance

### Headless Operation
When running as an AI agent, commands like `jump` or `thaw` may report "attachment errors" (e.g., `Failed to attach to tmux session`). **This is expected in non-interactive environments.**
- The session **is** created successfully even if attachment fails.
- Do not attempt to retry the attachment.
- Instead, use the `tmux-interaction` skill to verify and interact with the session.

### Integration with tmux-interaction
- **Macro-Management (Sentinel)**: Use for environment setup, recovery, and high-level state management.
- **Micro-Management (Interaction)**: After a `jump` or `thaw`, use the interaction skill to:
    - Capture pane content (`capture-clean`) to verify the environment.
    - Send keys to start specific background processes.
    - Wait for patterns or logs to confirm application readiness.

### Troubleshooting
- **SIGSYS Errors**: Common on Android/Termux with pre-built binaries. The `install_deps.sh` script handles this by building from source if `go` is available.
- **Path Issues**: Ensure `~/.local/bin` is in the environment's `PATH`.

## Configuration
Declarative layouts are stored in `configs/*.yml` and follow the `smug` configuration schema.
