#!/bin/bash
# pre_hibernate.sh <session_name>
SESSION=$1

if [ -z "$SESSION" ]; then
    echo "Usage: $0 <session_name>"
    exit 1
fi

echo "Scanning session '$SESSION' for active applications..."

# Get all panes in the session
PANES=$(tmux list-panes -s -t "$SESSION" -F "#{window_index}.#{pane_index}")

for PANE in $PANES; do
    # Get the foreground process in the pane
    PANE_TTY=$(tmux display-message -p -t "$SESSION:$PANE" "#{pane_tty}")
    FG_PROCESS=$(ps -t "$PANE_TTY" -o comm= | head -n 1)

    case "$FG_PROCESS" in
        nvim|vim)
            echo "Detected $FG_PROCESS in pane $PANE. Sending save command..."
            # Send Escape to ensure we are in Normal mode, then save and exit
            tmux send-keys -t "$SESSION:$PANE" C-[ ":wa" Enter
            # If they use auto-session or similar, we might want to just save
            # For now, we save all buffers. We don't necessarily want to quit if smug will kill the pane anyway.
            sleep 1
            ;;
        *)
            # echo "No specific hook for $FG_PROCESS in pane $PANE"
            ;;
    esac
done

echo "Pre-hibernate hooks completed."
