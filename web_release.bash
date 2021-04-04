#!/bin/bash

# Build and run web app
echo 'Starting...'


echo 'Building web release...'

cd kanbansim
flutter pub get
flutter build web
cd ..
echo 'Finished.'


echo 'Building github webpages directory...'
rm -r docs
mkdir docs
cp -r kanbansim/build/web/* docs/.

# Rename paths for github weg pages
cd docs
sed -i 's/"assets\/"/"KanbanMethodSimApp\/assets\/"/g' main.dart.js
sed -i "s/'main.dart.js';/'KanbanMethodSimApp\/main.dart.js';/g" index.html
cd ..
echo 'Finished.'

echo 'Pushing changes into github pages...'
git switch -c release-web-demo
#git push origin
echo 'Finished.'


echo 'Script finished.'
