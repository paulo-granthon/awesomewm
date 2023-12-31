#!/bin/bash

directory='./themes/'

# Get the THEME argument passed to the script
THEME="$1"

for file in "$directory"*.lua; do
    if [ -f "$file" ]; then
        moduleName=$(basename "$file" .lua)
        echo "$moduleName"
        if [ "$moduleName" != "$file" ]; then
            if [ "$moduleName" == "$THEME" ]; then
                echo "The '$THEME' theme exists in directory"
                exit 0
            fi
        fi
    fi
done

echo "Theme file not found"

exit 1
