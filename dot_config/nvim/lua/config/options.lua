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

if vim.fn.executable("clipcli") then
  vim.g.clipboard = {
    name = "clipcli",
    copy = {
      ["+"] = { "clipcli", "set" },
      ["*"] = { "clipcli", "set" },
    },
    paste = {
      ["+"] = { "clipcli", "get" },
      ["*"] = { "clipcli", "get" },
    },
    cache_enabled = 1,
  }
end
