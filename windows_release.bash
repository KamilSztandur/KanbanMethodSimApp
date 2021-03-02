#!/bin/bash

# Build and run windows desktop app 
echo 'Starting...'

cd kanbansim
flutter pub get
flutter build windows

cd build/windows/runner/Release
./testowa.exe

echo 'Finished.'
