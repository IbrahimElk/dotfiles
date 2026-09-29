#!/bin/bash

# current_transform=$(
#     hyprctl monitors -j |
#     jq -r '.[] | select(.name == "eDP-1") | .transform'
# )
current_transform=$(hyprctl monitors | grep "transform" |awk -F'transform: ' '{print $2}')

case "$current_transform" in
    0)
        echo "damned be i"
        hyprctl eval 'hl.monitor({ output = "eDP-1", transform = 1 })'
        ;;
    1)
        echo "nice"
        hyprctl eval 'hl.monitor({ output = "eDP-1", transform = 2 })'
        ;;
    2)
        echo "no way"
        hyprctl eval 'hl.monitor({ output = "eDP-1", transform = 3 })'
        ;;
    3)
        echo "i'\''ll be damned way"
        hyprctl eval 'hl.monitor({ output = "eDP-1", transform = 0 })'
        ;;
    *)
        echo "Error: Unknown transform state: $current_transform"
        exit 1
        ;;
esac


# WL_OUTPUT_TRANSFORM_NORMAL = 0
# WL_OUTPUT_TRANSFORM_90 = 1
# WL_OUTPUT_TRANSFORM_180 = 2
# WL_OUTPUT_TRANSFORM_270 = 3
# WL_OUTPUT_TRANSFORM_FLIPPED = 4
# WL_OUTPUT_TRANSFORM_FLIPPED_90 = 5
# WL_OUTPUT_TRANSFORM_FLIPPED_180 = 6
# WL_OUTPUT_TRANSFORM_FLIPPED_270 = 7
