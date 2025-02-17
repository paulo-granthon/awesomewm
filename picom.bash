#!/bin/bash
killall -q picom

SLEEP_AMOUNT=.001

while pgrep -u $UID -x picom >/dev/null; do
  sleep $SLEEP_AMOUNT
done

picom --config ~/.config/picom/picom.conf -b
