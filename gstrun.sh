#!/bin/bash

SCRIPT="$1"

if [ -z "$SCRIPT" ]; then
  echo "🟢 No script provided. Launching interactive GNU Smalltalk shell..."
  docker run --rm -it \
    -e DISPLAY=:99 \
    abuajamieh/gnu-smalltalk \
    bash -c "
      Xvfb :99 -screen 0 1024x768x16 2>/dev/null &
      export DISPLAY=:99
      sleep 1
      exec gst"
  exit 0
fi

# Resolve full path and relative path
FULL_PATH="$(realpath "$SCRIPT")"
SCRIPT_NAME="$(basename "$FULL_PATH")"
SCRIPT_DIR="$(dirname "$FULL_PATH")"

echo "🚀 Running $SCRIPT_NAME from $SCRIPT_DIR in a one-time Docker container..."

docker run --rm -it \
  -v "$SCRIPT_DIR:/scripts" \
  -e DISPLAY=:99 \
  abuajamieh/gnu-smalltalk \
  bash -c "
    Xvfb :99 -screen 0 1024x768x16 2>/dev/null &
    export DISPLAY=:99
    sleep 1
    exec gst /scripts/$SCRIPT_NAME"
