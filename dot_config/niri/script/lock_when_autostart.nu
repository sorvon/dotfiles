plugin add nu_plugin_formats
plugin use formats
if (cat /etc/sddm.conf | from ini | get -o Autologin | get -o Session) == niri {
  while (ps | find qs | length) == 0 { sleep 1sec }
  qs -c noctalia-shell ipc call lockScreen lock
}
