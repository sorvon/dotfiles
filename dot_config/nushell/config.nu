use std/config *

if $env.HOME? == null {
  $env.HOME = $'($env.HOMEDRIVE)\($env.HOMEPATH)'
}
$env.COLORTERM = "truecolor"
$env.EDITOR = "helix"
$env.SHELL = "nu"
$env.MANPAGER = "nvim +Man!"

$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.config.table.mode = "rounded"
$env.config.edit_mode = 'helix'
$env.config.keybindings ++= [
  {
    name: BackspaceWordAltBackspace
    modifier: alt
    keycode: backspace
    mode: [vi_insert vi_normal emacs helix_insert]
    event: { edit: BackspaceWord}
  }
  {
    name: BackspaceWordCtrlH
    modifier: control
    keycode: Char_h
    mode: [vi_insert vi_normal emacs helix_insert]
    event: { edit: BackspaceWord}
  }
  {
    name: Unfreeze
    modifier: control
    keycode: Char_z
    mode: [vi_insert vi_normal emacs helix_insert]
    event: {
      send: executehostcommand,
      cmd: "job unfreeze"
    },
  }
]

alias chez = chezmoi
alias cz = chezmoi
alias ze =   zellij
alias hx = helix

$env.LS_COLORS = (vivid generate snazzy)
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

$nu.user-autoload-dirs | each {mkdir $in}
const venv_list = [".venv/bin/activate.nu", "venv/bin/activate.nu"]
try { 
  $venv_list | where ($it | path exists) | first | path expand | $"overlay use ($in)" | save ($nu.user-autoload-dirs | first | path join activate.nu) 
} catch { rm -f $"($nu.user-autoload-dirs | first)/activate.nu"}

def --env set_proxy [ip: string port: string] {
  load-env {
    http_proxy: $"http://($ip):($port)", 
    https_proxy: $"http://($ip):($port)",
    all_proxy: $"socks5://($ip):($port)",
  }
}


def --env hide_proxy [] {
  hide-env  http_proxy https_proxy all_proxy
}

def pacman_sort [] {
  pacman -Qi | rg 'Name[^:]+: ' -r '' | lines 
  | zip (pacman -Qi | rg 'Installed Size[^:]+: ' -r '' | str replace -a "i" "" | lines) 
  | reduce -f [[name size]; [0 0]] { |el acc| $acc | append [{name:$el.0 size:($el.1 | into filesize)}] } 
  | skip 1 | sort-by size
}

def --env y [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXXX")
  yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != "" and $cwd != $env.PWD {
    cd $cwd
  }
  rm -fp $tmp
}

def --wrapped mvn8 [...args] {
  $env.JAVA_HOME = "/usr/lib/jvm/java-8-openjdk"
  mvn ...$args
}
const NU_PLUGIN_DIRS = [
  ($nu.current-exe | path dirname)
  ...$NU_PLUGIN_DIRS
]

def clip-get [--server (-s): string] {
  let env_server = $env.CLIPBOARD_SYNC_CLI_SERVER?
  let server = if $server != null {
    $server
  } else {
    $env_server
  }
  if $server == null {
    return nativepaste
  }
  curl -s $"http://($server)/clipboard/text"
}

def clip-set [--server (-s): string] {
  let text = $in
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
      $text | ccat | curl -s -X POST $"http://($server)/clipboard/text" --data-binary @-
    } else {
      $text | osc52copy
      return $text
    }
  } else {
    $text | ccat | curl -s -X POST $"http://($server)/clipboard/text" --data-binary @-
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
  let encoded = ($in | ccat | encode base64)
  let seq = $"\e]52;c;($encoded)(char bel)"
  let tty = if $nu.os-info.name == "windows" { "CONOUT$" } else { "/dev/tty" }
  job spawn {
    $"($seq) | save -f ($tty)"
  }
} 

def nativepaste [] {
  if $nu.os-info.name == "windows" {
    powershell.exe -NoLogo -NoProfile -c '[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
  } else if $env.WAYLAND_DISPLAY != null {
    wl-paste
  } else if $env.DISPLAY != null {
    xclip -o
  } else {
    ""
  }
} 

def code_runner [buffer_name: string, langauge: string, cursor_line = 0] {
  use std/log
  let buffer_name = $buffer_name | path expand
  log info $"($buffer_name):($cursor_line)[($langauge)]"
  match $langauge {
    "nu" => {
      nu $buffer_name
    }
    "python" => {
      run-python $buffer_name
    }
    "hurl" => {
      run-hurl $buffer_name $cursor_line
    }
    _ => { log info $"不支持的语言($langauge)" }
  }
}

def run-python [buffer_name: string] {
  def has_import [file: path, pkg: string] {
    let pat = '(?m)^\s*(import\s+' + $pkg + '\b|from\s+' + $pkg + '\s+import\b)'
    open $file --raw | $in =~ $pat
  }
  let has_xlwings = has_import $buffer_name "xlwings"
  if $nu.os-info.name != "windows" and $has_xlwings {
    /mnt/c/Users/dingyh54129/AppData/Local/Programs/Python/Python314/python.exe -u $buffer_name
  } else {
    uv run $buffer_name
  }
}

def run-hurl [buffer_name: string, cursor_line = 0] {
  def is_hurl_entry [line: string]: nothing -> bool {
    let method_list = [GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH]
    for method in $method_list {
      if $line =~ $"^($method)" {
        return true
      }
    }
    false
  }
  const hurl_dir = "~/.cache/hurl"
  let line_list = open -r $buffer_name | lines
  mut buffer = []
  mut out_name = $buffer_name
  mut index = $cursor_line
  loop {
    let cur_line = $line_list | get $index
    $buffer = $buffer | prepend $cur_line
    if (is_hurl_entry $cur_line) {
      print $cur_line
      $out_name = $cur_line | path parse | get stem
      break
    } else {
      $index = $index - 1
    }
  }
  $index = $cursor_line + 1
  while $index < ($line_list | length) {
    let cur_line = $line_list | get $index
    if (is_hurl_entry $cur_line) {
      break
    } else {
      $index = $index + 1
    }
    $buffer = $buffer | append $cur_line
  }
  $buffer = $buffer | where {
    |line|
    let cmd = $line | parse --regex '^#\s*cmd:\s*(?<cmd>.+)'
    | get cmd.0?
    if $cmd != null {
      let out = nu -c ($cmd | str trim | str trim -c '"')
      return false
    }
    if $line =~ '^\s*#' {
      return false
    }
    true
  }
  let date_str = date now | format date "%y%m%d_%H%M%S"
  let req_path = [$hurl_dir, $"($out_name)_($date_str).hurl"] | path join | path expand
  let res_path = [$hurl_dir, $"($out_name)_($date_str)_res.hurl"] | path join | path expand
  mkdir $hurl_dir
  $buffer | to text | save -f $req_path
  mut opts = ["--pretty" "--verbose" $req_path]
  let var_file = $buffer_name | path expand | path basename -r "vars.env"
  if ($var_file | path exists) {
    $opts = $opts ++ [--variables-file $var_file]
  }
  print $opts
  let res_data = hurl ...$opts | complete
  # $res_data | save -f $res_path
  let res_stdout = $res_data | get stdout
  let res_stderr = $res_data | get stderr
  $res_stdout + $res_stderr
}

def zellij-update-tabname [] {
  if ("ZELLIJ" not-in $env) {
    return
  }
  try {
    let tab_index = zellij action current-tab-info -j | from json | get position | into int
    mut tabname = "";
    let path = $env.PWD
    let dir = if $path == $env.HOME {
      "~"
    } else {
      $path | path basename
    }
    $tabname = $"($tab_index + 1).($dir)";

    zellij action rename-tab $tabname;
  }
}

$env.config.hooks = {
  pre_execution: [
    { zellij-update-tabname }
  ],
  env_change: {
    PWD: [
      { zellij-update-tabname }
      {||
        if (which direnv | is-empty) {
          # If direnv isn't installed, do nothing
          return
        }
        let e = direnv export json | from json | default {}
        let e = $e | items {
          |key, value|
          let up_value = $e | get -o ($key | str uppercase)
          if ($value | is-empty) {
            { $key: $up_value }
          } else {
            { $key: $value }
          }
        } | into record

        $e | update cells --columns [ PATH ] {
          do (env-conversions).path.from_string $in
        } | load-env
      }
    ]
  }
}

# cargo
if ("~/.cargo/env.nu" | path exists) {
  source "~/.cargo/env.nu"
}
# cargo end

# pnpm
$env.PNPM_HOME = "/home/dyh/.local/share/pnpm"
$env.PATH = ($env.PATH | split row (char esep) | prepend $env.PNPM_HOME )
# pnpm end
