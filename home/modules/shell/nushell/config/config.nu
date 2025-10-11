# https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/sample_config/default_config.nu

$env.config.show_banner = false
$env.config.buffer_editor = 'vim'
$env.config.datetime_format = {
  normal: '%a, %d %b %Y %H:%M:%S %z'    # shows up in displays of variables or other datetime's outside of tables
  table: '%y-%m-%d %I:%M:%S%p'          # generally shows up in tabular outputs such as ls. commenting this out will change it to the default human readable datetime format
}

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
  env "http_proxy=" "https_proxy=" xfreerdp /u:docker /p:"" /size:3456x1944 /v:127.0.0.1:3389 /cert:ignore /sec:tls
}


def greet [] {
  krabby random --no-title
}
greet
