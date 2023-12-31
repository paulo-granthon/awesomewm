#!/bin/bash

# capture the PID of awesomewm process
AWESOME_PID=$(ps ax | grep awesome | grep -m 1 -o "^ *[0-9][0-9]*" | sed -n "s/^\s*\([0-9][0-9]*\)\s*$/\1/p")

# start `tail -f` to continuously display the logs of awesomewm
tail -f /proc/${AWESOME_PID}/fd/2
