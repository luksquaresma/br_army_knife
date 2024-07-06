#!/bin/bash
# Configs
source ./utils.sh
directory_distr="./dist"
directory_venv="./.venv"
pyproject_toml_path="./pyproject.toml"
max_upload_retries=3
python_pkgs=(
    "pip"
    "build"
    "twine"
    "setuptools"
)


echo; echo "...PYTHON BUILD SCRIPT..."
{  
    echo; if (fok "Do you wish to use a local venv enviroment?"); then

        echo; echo "...Local enviroment preparation..."
        {
            echo; if (fok "Do you wish to reset the local venv enviroment?"); then  
                {
                    if [ -d "$directory_venv" ]; then
                        rm -rf "$directory_venv"/*
                        echo "INFO - Enviroment reset on: $directory_venv"
                    else
                        mkdir -p "$directory_venv"
                        echo "INFO - Directory created: $directory_venv"
                    fi
                } && {
                    echo; python3 -m venv $directory_venv
                }
            fi
        } && {
            source $directory_venv/bin/activate
        } && {
            echo; echo "OK - local venv enviroment setup."
        }
    fi
} && {
    echo; if (fok "Do you wish to install python packages in the current enviroment?"); then

        echo; echo "...Ptyhon package installation..."
        
        for p in "${python_pkgs[@]}"; do
            echo; pip install --upgrade $p --break-system-packages
            if [ $? -eq 1 ]; then
                echo; echo "ERROR - Installing python package $p!"
                exit 1
            else
                echo; echo "INFO - Python package $p Installed!"
            fi
        done
        echo; echo "OK - Ptyhon package installation successful."
    fi
} && {
    echo; echo "...File preparation..."

    if [ -d "$directory_distr" ]; then
        rm -rf "$directory_distr"/*
    else
        mkdir -p "$directory_distr"
        echo "Directory created: $directory_distr"
    fi
    echo; echo "OK - File preparation successful."
} && {
    echo; echo "...Build process..."
    {
        (iterate_version_toml $pyproject_toml_path)
    } && {
        python3 -m build
        if [ $? -eq 1 ]; then
            echo; echo "ERROR - Build failed!"
            exit 1
        else
            echo; echo "OK - Build successful."
        fi  
    } 
} && {
    echo; if (fok "Do you wish to intall locally?"); then
        
        echo; echo "...Local installation process..."
        
        pip install -e .
        if [ $? -eq 1 ]; then
            echo; echo "ERROR - Installation failed!"
            exit 1
        else
            echo; echo "OK - Installation successful."
        fi
    fi 
} && {
    echo; if (fok "Do you wish to upload to PyPi?"); then
        
        echo; echo "...Upload process..."
        
        upload_attempts=0
        while [ $upload_attempts -lt $max_upload_retries ]; do
            echo; python3 -m twine upload --repository pypi dist/*
            if [ $? -eq 0 ]; then
                echo; echo "OK - Upload successful."
                break
            else
                echo; echo "INFO - Upload failed, retrying..."
                ((upload_attempts++))
            fi
        done

        if [ $upload_attempts -eq $max_upload_retries ]; then
            echo; echo "ERROR - Maximum upload attempts reached, upload failed."
        fi
    fi
} && {
    echo; echo "...END OF SCRIPT..."; echo;
}