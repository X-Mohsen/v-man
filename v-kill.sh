#!/bin/bash

arg="$1"
pid_file="./daemons/$arg.pid"

# Check if the PID file exists
if [ ! -f "$pid_file" ]; then
  echo "No PID file found for $arg. Is the VM running?"
  exit 1
fi

# Read the PID from the file
pid=$(cat "$pid_file")

# Check if the process is running
if ps -p "$pid" > /dev/null; then
  echo "Killing process $pid for $arg..."
  echo "You may need sudo permission to kill this proccess."
  sudo kill "$pid"  # Terminate the process gracefully
else
  echo "No running process with PID $pid. It may already be stopped."
fi
