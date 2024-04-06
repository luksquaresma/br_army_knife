#!/bin/bash
echo "File preparation..."

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

echo "Build process..."
python3 -m build


echo "Upload process..."
# Check if the build command was successful
if [ $? -eq 0 ]; then
    # Set the maximum number of upload retries
    max_upload_retries=3
    upload_attempts=0

    # Loop until the upload is successful or the maximum number of retries is reached
    while [ $upload_attempts -lt $max_upload_retries ]; do
        python3 -m twine upload --repository pypi dist/*
        
        # Check if the upload command was successful
        if [ $? -eq 0 ]; then
            echo "Upload successful."
            break
        else
            echo "Upload failed, retrying..."
            ((upload_attempts++))
        fi
    done

    # Check if the maximum number of retries was reached
    if [ $upload_attempts -eq $max_upload_retries ]; then
        echo "Maximum upload attempts reached, upload failed."
    fi
else
    echo "Build failed, not uploading to PyPI."
fi