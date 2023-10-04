#!/bin/bash

directory='./themes/'

# Get the THEME argument passed to the script
THEME="$1"

for file in "$directory"*.lua; do
    if [ -f "$file" ]; then
        moduleName=$(basename "$file" .lua)
        if [ "$moduleName" != "$file" ]; then
            if [ "$moduleName" == "$THEME" ]; then
                THEME="$moduleName"
                echo "$THEME"
                exit 0
            fi
        fi
    fi
done

exit 1
