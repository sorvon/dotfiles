-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mkdp_open_to_the_world = 1
vim.g.mkdp_echo_preview_url = 1
vim.g.autoformat = false
vim.opt.fileencodings = "ucs-bom,utf-8,gbk,default,latin1"
vim.opt.textwidth = 300
vim.opt.smartindent = true
vim.opt.expandtab = true
if vim.g.neovide then
  require("config.neovide")
end

vim.g.clipboard_sync_cli_server = vim.fn.getenv("CLIPBOARD_SYNC_CLI_SERVER")
if vim.g.clipboard_sync_cli_server ~= vim.NIL and vim.fn.executable("clipboard_sync_cli") then
  vim.g.clipboard = {
    name = "clipboard_sync_cli",
    copy = {
      ["+"] = { "clipboard_sync_cli", "set" },
      ["*"] = { "clipboard_sync_cli", "set" },
    },
    paste = {
      ["+"] = { "clipboard_sync_cli", "get" },
      ["*"] = { "clipboard_sync_cli", "get" },
    },
    cache_enabled = 1,
  }
end
