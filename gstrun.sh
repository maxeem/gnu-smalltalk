#!/bin/bash

SCRIPT="$1"

if [ -z "$SCRIPT" ]; then
  echo "❌ Please provide a Smalltalk script filename or full path"
  exit 1
fi

# Resolve full path and relative path
FULL_PATH="$(realpath "$SCRIPT")"
SCRIPT_NAME="$(basename "$FULL_PATH")"
SCRIPT_DIR="$(dirname "$FULL_PATH")"
SCRIPT_RELATIVE="${FULL_PATH#$SCRIPT_DIR/}"  # This will just be $SCRIPT_NAME

echo "🚀 Running $SCRIPT_NAME from $SCRIPT_DIR in a one-time Docker container..."

docker run --rm \
  -v "$SCRIPT_DIR:/scripts" \
  abuajamieh/gnu-smalltalk \
  bash -c "
    Xvfb :99 -screen 0 1024x768x16 2>/dev/null &
    export DISPLAY=:99
    sleep 1
    gst /scripts/$SCRIPT_NAME
  "
