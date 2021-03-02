#!/bin/bash

# Build all releases
echo 'Starting...'

cd kanbansim
flutter pub get
flutter build windows
flutter build linux
flutter build macos
flutter build web

echo 'Finished.'
