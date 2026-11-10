def "main get" [--server (-s): string] {
  let env_server = $env.CLIPBOARD_SYNC_CLI_SERVER?
  let server = if $server != null {
    $server
  } else {
    $env_server
  }
  if $server == null {
    return (nativepaste)
  }
  let ip_port = $server | split row ":"
  let ip = $ip_port| get -o 0
  let port = $ip_port | get -o 1
  if (which nc | length) > 0 {
    if (nc -z $ip $port | complete | get exit_code) == 0 {
      http get -r $"http://($server)/clipboard/text"
    } else {
      nativepaste
    }
  } else {
    http get -r $"http://($server)/clipboard/text"
  }
}
def "main set" [--server (-s): string] {
  let text = ($in | ccat)
  let env_server = $env.CLIPBOARD_SYNC_CLI_SERVER?
  let server = if $server != null {
    $server
  } else {
    $env_server
  }
  if $server == null {
    $text | osc52copy
    return $text
  }
  let ip_port = $server | split row ":"
  let ip = $ip_port| get -o 0
  let port = $ip_port | get -o 1
  if (which nc | length) > 0 {
    if (nc -z $ip $port | complete | get exit_code) == 0 {
      $text | ccat | http post -r $"http://($server)/clipboard/text"
    } else {
      $text | osc52copy
      return $text
    }
  } else {
    $text | ccat | http post -r $"http://($server)/clipboard/text"
  }
  $text
}
def ccat [] {
  match ($in | describe) {
    "binary" => ($in | decode gbk)
    _ => $in
  }
}
def osc52copy [] {
  use std/clip *
  let text = $in
  if $nu.os-info.name == "linux" {
    let seq = $'(ansi osc)52;c;($text | encode base64)(ansi st)'
    let tty = if (tty -s | complete | get exit_code) == 0 {
      /dev/tty
    } else {
      let ppid = ps | find $nu.pid | get ppid | first
      $"/proc/($ppid)/fd/1"
    }
    $seq | save -f $tty
  } else if $nu.os-info.name == "windows" {
    $text | encode gbk | clip.exe
  }
}
def nativepaste [] {
  if $nu.os-info.name == "windows" {
    powershell.exe -NoLogo -NoProfile -c '[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))' | ccat
  } else if $env.WAYLAND_DISPLAY != null {
    wl-paste
  } else if $env.DISPLAY != null {
    xclip -o
  } else {
    ""
  }
}

const self = path self
def main [] {
  nu $self -h
}
