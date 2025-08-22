# config.nu
#
# Installed by:
# version = "0.104.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.
$env.config.buffer_editor = "nvim" 
$env.config.show_banner = false 
$env.config.table.mode = "rounded"
$env.config.edit_mode = 'vi'
alias chez = chezmoi 
alias sudo = sudo -E

$env.LS_COLORS = (vivid generate snazzy)
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

$nu.user-autoload-dirs | each {mkdir $in}
const venv_list = [".venv/bin/activate.nu", "venv/bin/activate.nu"]
try { 
  $venv_list | where ($it | path exists) | first | path expand | $"overlay use ($in)" | save ($nu.user-autoload-dirs | first | path join activate.nu) 
} catch { rm -f $"($nu.user-autoload-dirs | first)/activate.nu"}

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
