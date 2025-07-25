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
# $env.GPG_AGENT_INFO = `gpgconf --list-dirs agent-socket | tr -d '\n' && echo -n ::`
gpgconf --launch gpg-agent

cat /etc/resolv.conf | grep nameserver | split row " " | last | load-env {
  DISPLAY: $"($in):0"
  http_proxy: $"http://($in):16191", https_proxy: $"http://($in):16191"
}

const NU_PLUGIN_DIRS = [
  ($nu.current-exe | path dirname)
  ...$NU_PLUGIN_DIRS
]
