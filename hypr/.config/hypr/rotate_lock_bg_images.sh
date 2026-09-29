#!/bin/sh
find ~/pictures/cats -type f \( -iname '*.jpg' -o -iname '*.png' \)  \
  | shuf -n1                                                         \
  | xargs -I{} ln -sf {} ~/.cache/hyprlock_bg
exec hyprlock
