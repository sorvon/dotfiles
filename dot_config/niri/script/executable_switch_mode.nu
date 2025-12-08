#!/usr/bin/env nu

const config_file = "~/.config/niri/config.kdl" | path expand
def main [mode: string] {
  sd '(include "mode\/)\w+(\.kdl")' $'${1}($mode)${2}' $config_file
  niri msg action load-config-file
}

