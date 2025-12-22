# env.nu
#
# Installed by:
# version = "0.104.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

$env.EDITOR = "nvim"
$env.GPG_TTY = (tty)
$env.PATH = ($env.PATH | prepend '~/workspace/cres/workspace/bin/')
$env.MANPAGER = "nvim +Man!"
gpgconf --launch gpg-agent

def --env set_proxy [ip: string port: string] {
  if (nc -z $ip $port | complete | get exit_code) == 0 {
    load-env {
      http_proxy: $"http://($ip):($port)", 
      https_proxy: $"http://($ip):($port)",
      all_proxy: $"socks5://($ip):($port)",
    }
  }
}

cat /etc/resolv.conf | grep nameserver | split row " " | last | do --env {
  if $in != "10.255.255.254" and $in != "10.26.232.2" { 
    set_proxy $in 16191
  } else {
    set_proxy "127.0.0.1" 16191
  }
} 

const NU_PLUGIN_DIRS = [
  ($nu.current-exe | path dirname)
  ...$NU_PLUGIN_DIRS
]

# pnpm
$env.PNPM_HOME = "/home/dyh/.local/share/pnpm"
$env.PATH = ($env.PATH | split row (char esep) | prepend $env.PNPM_HOME )
# pnpm end
