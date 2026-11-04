Copy-Item $env:USERPROFILE\.config\nvim $env:APPDATA -Recurse -Force
Copy-Item $env:USERPROFILE\.config\alacritty $env:APPDATA -Recurse -Force
Copy-Item $env:USERPROFILE\.config\helix $env:APPDATA -Recurse -Force
Copy-Item $env:USERPROFILE\.config\nushell $env:APPDATA -Recurse -Force
Copy-Item $env:USERPROFILE\.config\yazi $env:APPDATA -Recurse -Force
Copy-Item $env:USERPROFILE\.config\zellij $env:APPDATA -Recurse -Force
Copy-Item $env:USERPROFILE\.config\starship.toml $env:APPDATA -Force
