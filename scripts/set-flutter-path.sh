#!/bin/bash
# Bash script to set Flutter path
# Usage: source ./scripts/set-flutter-path.sh

export FLUTTER_PATH="/c/src/flutter/flutter/bin"

export PATH="$FLUTTER_PATH:$PATH"

echo "✅ Flutter path added to PATH: $FLUTTER_PATH"
flutter --version
