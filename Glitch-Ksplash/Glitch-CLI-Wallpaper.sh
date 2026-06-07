#!/bin/bash

#╭───────────────────────────────────────────╮
#│ CLI wallpaper changer for dynamic effects │
#│ Autorun this script on reboots or desktop │
#│ works with .gif's and static image files  │
#╰───────────────────────────────────────────╯

# Check internet connectivity
echo "Checking internet connectivity..."
if ! ping -c 1 8.8.8.8 &> /dev/null; then
    echo "No internet connection available. Exiting."
    exit 1
fi

echo "Internet connection confirmed!"

# Check if qdbus-qt5 is installed
if ! dpkg -l | grep -q '^ii.*qdbus-qt5'; then
    echo "qdbus-qt5 not found. Installing..."
    sudo apt update && sudo apt install qdbus-qt5 -y
    if [ $? -ne 0 ]; then
        echo "Failed to install qdbus-qt5. Exiting."
        exit 1
    fi
    echo "qdbus-qt5 installed successfully!"
fi

# Create directory
mkdir -p /tmp/ksplash/
cd /tmp/ksplash/
 
# Array of files to download
declare -a FILES=(
    "glitch-awakening-ksplash.gif"
    "glitch-convergence-ksplash.gif"
    "glitch-awakening-ksplash-boomerang.gif"
    "glitch-emergence-ksplash-boomerang.gif"
    "glitch-emergence-ksplash.gif"
    "preview-1.png"
    "preview-2.png"
    "preview-3.png"
    "preview-4.png"
)
 
# Base URLs (GitHub raw content)
GIFS_URL="https://raw.githubusercontent.com/GlitchLinux/Glitch-Plymouth/main/Glitch-Ksplash/glitch-ksplash-gif"
PNGS_URL="https://raw.githubusercontent.com/GlitchLinux/Glitch-Plymouth/main/Glitch-Ksplash/glitch-ksplash-png"
 
# Check if all files exist
all_exist=true
for file in "${FILES[@]}"; do
    if [ ! -f "$file" ]; then
        all_exist=false
        break
    fi
done
 
# Download if any files are missing
if [ "$all_exist" = false ]; then
    echo "Files missing. Starting downloads..."
    
    # Download GIFs
    for gif in glitch-awakening-ksplash-boomerang.gif glitch-awakening-ksplash.gif glitch-convergence-ksplash.gif glitch-emergence-ksplash-boomerang.gif glitch-emergence-ksplash.gif; do
        wget "$GIFS_URL/$gif"
    done
    
    # Download PNGs
    for i in {1..9}; do
        wget "$PNGS_URL/preview-$i.png"
    done
    
    echo "Download complete!"
else
    echo "All files already exist in /tmp/ksplash/. Skipping download."
fi

qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var allDesktops = desktops();
    for (var i = 0; i < allDesktops.length; i++) {
        allDesktops[i].wallpaperPlugin = 'org.kde.image';
        allDesktops[i].currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
        allDesktops[i].writeConfig('Image', 'file:////tmp/ksplash/glitch-convergence-ksplash.gif');
    }
"

sleep 10

qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var allDesktops = desktops();
    for (var i = 0; i < allDesktops.length; i++) {
        allDesktops[i].wallpaperPlugin = 'org.kde.image';
        allDesktops[i].currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
        allDesktops[i].writeConfig('Image', 'file:////tmp/ksplash/preview-1.png');
    }
"

qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var allDesktops = desktops();
    for (var i = 0; i < allDesktops.length; i++) {
        allDesktops[i].wallpaperPlugin = 'org.kde.image';
        allDesktops[i].currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
        allDesktops[i].writeConfig('Image', 'file:////tmp/ksplash/preview-2.png');
    }
"

qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var allDesktops = desktops();
    for (var i = 0; i < allDesktops.length; i++) {
        allDesktops[i].wallpaperPlugin = 'org.kde.image';
        allDesktops[i].currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
        allDesktops[i].writeConfig('Image', 'file:////tmp/ksplash/preview-3.png');
    }
"

qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var allDesktops = desktops();
    for (var i = 0; i < allDesktops.length; i++) {
        allDesktops[i].wallpaperPlugin = 'org.kde.image';
        allDesktops[i].currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
        allDesktops[i].writeConfig('Image', 'file:////tmp/ksplash/glitch-emergence-ksplash-boomerang.gif');
    }
"

qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var allDesktops = desktops();
    for (var i = 0; i < allDesktops.length; i++) {
        allDesktops[i].wallpaperPlugin = 'org.kde.image';
        allDesktops[i].currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
        allDesktops[i].writeConfig('Image', 'file:////tmp/ksplash/preview-4.png');
    }
"

sleep 500 && bash /usr/local/bin/Glitch-CLI-Wallpaper.sh
