if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    speed=$(gum input --placeholder "Fan Speed 30-100")
else
    speed=$1
fi

sudo nvidia-settings --display :1.0 -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=$speed"
