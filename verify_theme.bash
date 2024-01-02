#!/bin/bash

DIRECTORY="$HOME/.config/awesome/themes/"
THEME="$1"

for file in "$DIRECTORY"*.lua; do
    if [ -f "$file" ]; then
        moduleName=$(basename "$file" .lua)
        echo "this file is in dir: $moduleName"
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
