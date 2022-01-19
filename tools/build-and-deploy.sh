#!/bin/sh

# set -e

which butler

echo "Checking application versions..."
echo "-----------------------------"
cat ~/.local/share/godot/templates/3.4.stable/version.txt
godot --version
butler -V
echo "-----------------------------"

mkdir build/
mkdir build/linux/
mkdir build/osx/
mkdir build/win/

echo "EXPORTING FOR LINUX"
echo "-----------------------------"
godot --export "Linux/X11" build/linux/diedle.x86_64 -v
# echo "EXPORTING FOR OSX"
# echo "-----------------------------"
# godot --export "Mac OSX" build/osx/diedle.dmg -v
echo "EXPORTING FOR WINDOZE"
echo "-----------------------------"
godot --export-debug "Windows Desktop" build/win/diedle.exe -v
echo "-----------------------------"

# echo "CHANGING FILETYPE AND CHMOD EXECUTABLE FOR OSX"
# echo "-----------------------------"
# cd build/osx/
# mv diedle.dmg diedle-osx-alpha.zip
# unzip diedle-osx-alpha.zip
# rm diedle-osx-alpha.zip
# chmod +x diedle.app/Contents/MacOS/diedle
# zip -r diedle-osx-alpha.zip diedle.app
# rm -rf diedle.app
# cd ../../

ls -al
ls -al build/
ls -al build/linux/
ls -al build/osx/
ls -al build/win/

echo "ZIPPING FOR WINDOZE"
echo "-----------------------------"
cd build/win/
zip -r diedle-win-alpha.zip diedle.exe diedle.pck
rm -r diedle.exe diedle.pck
cd ../../

echo "ZIPPING FOR LINUX"
echo "-----------------------------"
cd build/linux/
zip -r diedle-linux-alpha.zip diedle.x86_64 diedle.pck
rm -r diedle.x86_64 diedle.pck
cd ../../

echo "Logging in to Butler"
echo "-----------------------------"
butler login

echo "Pushing builds with Butler"
echo "-----------------------------"
butler push build/linux/ synsugarstudio/diedle:linux-alpha
# butler push build/osx/ synsugarstudio/diedle:osx-alpha
butler push build/win/ synsugarstudio/diedle:win-alpha
