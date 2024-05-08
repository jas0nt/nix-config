# https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/sample_config/default_config.nu

$env.config = {
  show_banner: false

  datetime_format: {
    normal: '%a, %d %b %Y %H:%M:%S %z'    # shows up in displays of variables or other datetime's outside of tables
    table: '%y-%m-%d %I:%M:%S%p'          # generally shows up in tabular outputs such as ls. commenting this out will change it to the default human readable datetime format
  }
}
