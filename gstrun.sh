#!/bin/bash
# Maksim A.
set -e

# Usage: ./run-smalltalk-in-docker.sh myscript.st
# Assumes your Docker image is named: gnu-smalltalk:latest

SCRIPT="$1"

if [ -z "$SCRIPT" ]; then
  echo "Usage: $0 <smalltalk-script.st>"
  exit 1
fi

# If no extension is given, assume .st
if [[ "$SCRIPT" != *.st ]]; then
  SCRIPT="${SCRIPT}.st"
fi

# If not a full path, assume current directory
if [ ! -f "$SCRIPT" ]; then
  if [ -f "./$SCRIPT" ]; then
    SCRIPT="./$SCRIPT"
  else
    echo "❌ File not found: $SCRIPT"
    exit 1
  fi
fi

echo "🚀 Running $SCRIPT in a one-time Docker container..."

docker run --rm -v "$(pwd):/scripts" abuajamieh/gnu-smalltalk:latest gst "/scripts/$(basename "$SCRIPT")"
