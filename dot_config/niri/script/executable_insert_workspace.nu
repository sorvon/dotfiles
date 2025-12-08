#!/usr/bin/env nu

let data = niri msg -j workspaces | from json
let workspace_last = $data | sort-by idx | last
let workspace_current = $data | where $it.is_focused | first
if not $workspace_last.is_focused {
  niri msg action focus-workspace $workspace_last.idx
}
let data = niri msg -j workspaces | from json
let workspace_dev = $data | where $it.name == "dev" | first
let target_index = [($workspace_current.idx + 1) $workspace_dev.idx] | math min
niri msg action move-workspace-to-index $target_index
