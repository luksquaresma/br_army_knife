#!/bin/bash


fok() { read -p "$1 (y/N): " && [[ $REPLY =~ ^([yY][eE][sS]|[yY])$ ]] }

iterate_version() {
    echo $(echo ${version} | awk -F. -v OFS=. '{$NF=$NF+1;print}')
}

iterate_version_toml() {
    
    version=false
    prefix="version = "
    
    # cat $1 | while read line; do 
    while IFS= read -r line; do 
        # echo "Text read from file: $line"
        if [[ ${line:0:10} == $prefix ]]; then
            version=${line#*=}
            version=$(echo ${version#*=} | tr -d ' ')
            version=$(echo ${version#*=} | tr -d '"')
            next=$(iterate_version $version);
            break              
        fi
        done < "$1"
    
    if [[ $version != false ]]; then
        echo; echo "Found package version: $version"
        if (fok "Do you wish to iterate it?"); then
            echo; echo "New package version: $next"
            if (fok "Do you confirm?"); then
                newline=${line/$version/$next}
                sed -i s/"$line".*/"$newline"/ $1
                echo; echo "OK - Version iteration finished!"
            else
                echo; echo "INFO - Package version iteration not confirmed!"
                echo; echo "INFO - Proceeding without version iteration!"
            fi
        fi
    else
        echo; echo "ERROR - Package version not found!"
        exit 1
    fi
}