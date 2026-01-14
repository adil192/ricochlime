#!/bin/bash
# Patches the flutter_soloud package to remove precompiled WebAssembly libraries
# since they're not needed for non-web platforms.
# This patch will soon not be needed thanks to https://github.com/flutter/flutter/pull/176393.

if [ ! -d ".dart_tool" ]; then
  echo "Error: Run 'flutter pub get' before './patches/remove_wasm_libs.sh'"
  exit 1
fi

# Find PUB_CACHE if not already set (https://dart.dev/tools/pub/environment-variables)
if [ -z "$PUB_CACHE" ]; then
  if [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "win32"* ]]; then
    PUB_CACHE="$LOCALAPPDATA/Pub/Cache"
  else
    PUB_CACHE="$HOME/.pub-cache"
  fi
fi
echo "Using PUB_CACHE at: $PUB_CACHE"

# Remove asset references in pubspec.yaml
for pubspec_file in "$PUB_CACHE"/{hosted/pub.dev,git}/flutter_soloud-*/pubspec.yaml; do
  if [ ! -f "$pubspec_file" ]; then
    echo "Warning: pubspec.yaml not found in $pubspec_file"
    continue
  fi
  echo "Patching $pubspec_file"

  # pubspec.yaml contains assets like `web/*.wasm` and `web/*.js`
  # Remove lines containing `web/*.wasm` and `web/*.js`
  sed -i.bak -E '/^[[:space:]]*-[[:space:]]*web\/.*\.(js|wasm)[[:space:]]*$/d' "$pubspec_file"
done

echo "Done!"
