$env.EDITOR = "nvim"
$env.SHELL = "nu"
$env.MANPAGER = "nvim +Man!"

def --env set_proxy [ip: string port: string] {
  if (nc -z $ip $port | complete | get exit_code) == 0 {
    load-env {
      http_proxy: $"http://($ip):($port)", 
      https_proxy: $"http://($ip):($port)",
      all_proxy: $"socks5://($ip):($port)",
    }
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
