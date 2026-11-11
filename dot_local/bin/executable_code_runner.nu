#!/usr/bin/env nu
 
const self = path self
def --wrapped  main [...args] {
  if $env.ZELLIJ? != null {
    let _ = zellij run -f -- nu $self run ...$args
  } else {
    nu $self run ...$args
  }
}

def "main run" [buffer_name: string, langauge: string, cursor_line = 0] {
  use std/log
  let buffer_name = $buffer_name | path expand
  log info $"($buffer_name):($cursor_line)[($langauge)]"
  
  let res = timeit --output  {
    try {
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
    } catch {
      |e|
      $e
    }
  }
  print "====================================="
  print ($res | get output | to text)
  print ($res | get time)
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
}
