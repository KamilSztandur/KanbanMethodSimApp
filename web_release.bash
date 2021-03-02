#!/bin/bash

# Build and run web app
echo 'Starting...'

cd kanbansim
flutter pub get
flutter build web
flutter run -d chrome

echo 'Finished.'
