#!/bin/bash
echo "...File preparation..."

directory_to_exclude="./dist"

# Check if the directory exists
if [ -d "$directory_to_exclude" ]; then
    # Remove all contents of the directory
    rm -rf "$directory_to_exclude"/*
else
    # Create the directory
    mkdir -p "$directory_to_exclude"
    echo "Directory created: $directory_to_exclude"
fi

echo "...Build process..."
python3 -m build

echo "...Local install process..."
pip install -e .