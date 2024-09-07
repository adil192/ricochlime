#!/bin/bash

DEPS=(simulator golden_screenshot)
for dep in "${DEPS[@]}"; do
  echo "Removing $dep from pubspec.yaml"
  sed -i -e "/$dep/d" pubspec.yaml
done

echo Deleting the \`main_simulator.dart\` entry point
rm lib/main_simulator.dart
