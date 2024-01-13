#!/bin/bash

THEME_FULL_PATH="$1"

if [ -z "$THEME_FULL_PATH" ]; then
    echo "Theme name is required"
    exit 1
fi

# get the directory by removing the file name from THEME
DIRECTORY=$(dirname "$THEME_FULL_PATH")

# get the file name by removing the directory from THEME and removing the extension
THEME=$(basename "$THEME_FULL_PATH" .lua)

for file in "$DIRECTORY/"*.lua; do
    if [ -f "$file" ]; then

        moduleName=$(basename "$file" .lua)

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
