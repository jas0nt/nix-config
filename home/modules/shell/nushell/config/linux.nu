def gpu_fan [
    pct: int
    --gpu: int = 0
] {
    if $pct < 30 or $pct > 100 {
        error make {msg: "The valid values for 'GPUTargetFanSpeed' are in the range 30 - 100 (inclusive)，current: ($pct)"}
    }
    sudo nvidia-settings -a $"[gpu:($gpu)]/GPUFanControlState=1" -a $"[fan:($gpu)]/GPUTargetFanSpeed=($pct)" --display :1.0 | ignore
}

def win [] {
	niri msg action move-window-to-workspace download
	docker compose -f ~/dkr/windows.yaml up --detach
	sleep 5sec
  env "http_proxy=" "https_proxy=" xfreerdp /u:docker /p:admin /size:3456x1944 /v:127.0.0.1:3389 /cert:ignore /sec:tls
}
