#!/bin/bash

PID_FILE="/tmp/activity.pid"
SCRIPT_FILE="/tmp/activity.sh"

# Create the script file if it doesn't exist
cat > "$SCRIPT_FILE" <<EOF
#!/bin/bash
while true; do
  xdotool mousemove_relative 1 0
  xdotool mousemove_relative -- -1 0
done
EOF

chmod +x "$SCRIPT_FILE"

# Toggle logic
if [ -f "$PID_FILE" ]; then
  kill "$(cat "$PID_FILE")" 2>/dev/null
  rm "$PID_FILE"
  notify-send "Activity" "Stopped"
else
  nohup bash "$SCRIPT_FILE" >/dev/null 2>&1 &
  echo $! > "$PID_FILE"
  notify-send "Activity" "Started"
fi
