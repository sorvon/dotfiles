$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.config.table.mode = "rounded"
$env.config.edit_mode = 'vi'
$env.config.keybindings ++= [
  {
    name: BackspaceWord
    modifier: alt
    keycode: backspace
    mode: [vi_insert vi_normal emacs]
    event: { edit: BackspaceWord}
  }
  {
    name: BackspaceWord
    modifier: control
    keycode: Char_h
    mode: [vi_insert vi_normal emacs]
    event: { edit: BackspaceWord}
  }
]
alias chez = chezmoi
alias ze = do {
  if $env.ZELLIJ? == null {
    printf '\e[?1004h'
  }
  zellij
}

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
  if (nc -z $ip $port | complete | get exit_code) == 0 {
    load-env {
      http_proxy: $"http://($ip):($port)", 
      https_proxy: $"http://($ip):($port)",
      all_proxy: $"socks5://($ip):($port)",
    }
  }
}

def --env hide_proxy [ip: string port: string] {
  hide-env  http_proxy https_proxy all_proxy
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
