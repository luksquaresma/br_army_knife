#!/bin/bash
echo "...File preparation..."

directory_to_exclude="./dist"

python3 -m pip install build --break-system-packages
sudo python3 -m pip install build --break-system-packages

{
    # Check if the directory exists
    if [ -d "$directory_to_exclude" ]; then
        # Remove all contents of the directory
        rm -rf "$directory_to_exclude"/*
    else
        # Create the directory
        mkdir -p "$directory_to_exclude"
        echo "Directory created: $directory_to_exclude"
    fi
} && {
    echo "...Build process..."
    python3 -m build
    sudo python3 -m build
} && {
    echo "...Local install process..."
    pip install -e . --break-system-packages
    sudo pip install -e . --break-system-packages
}
