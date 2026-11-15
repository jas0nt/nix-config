#!/usr/bin/env bash
set -euo pipefail

speed="${1:-}"
if [ -z "$speed" ]; then
    speed=$(gum input --placeholder "Fan Speed 30-100")
fi

if ! [[ "$speed" =~ ^[0-9]+$ ]] || [ "$speed" -lt 30 ] || [ "$speed" -gt 100 ]; then
    echo "Fan speed must be an integer between 30 and 100 (got: $speed)" >&2
    exit 1
fi

exec sudo nvidia-settings \
    --display :1.0 \
    -a "[gpu:0]/GPUFanControlState=1" \
    -a "[fan:0]/GPUTargetFanSpeed=$speed"
