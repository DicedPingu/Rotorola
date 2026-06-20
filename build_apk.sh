#!/usr/bin/env bash
set -e

echo "=== Clean Build ==="
flutter clean

echo "=== Get Dependencies ==="
flutter pub get

echo "=== Building Release APK ==="
flutter build apk --release

echo "=== Build Successful ==="
echo "Output APK file: build/app/outputs/flutter-apk/app-release.apk"
