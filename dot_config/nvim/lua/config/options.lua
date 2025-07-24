-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- vim.g.clipboard = {
--   name = 'wslclipboard',
--   copy = {
--     ["+"] = { "nvim-clip", "set" },
--     ["*"] = { "nvim-clip", "set" }
--   },
--   paste = {
--     ["+"] = { "nvim-clip", "get" },
--     ["*"] = { "nvim-clip", "get" }
--   },
-- }
vim.g.clipboard = {
  name = 'osc52',
  copy = {
    ["+"] = require('vim.ui.clipboard.osc52').copy('+'),
    ["*"] = require('vim.ui.clipboard.osc52').copy('+'),
  },
  paste = {
    ["+"] = 'wl-paste',
    ["*"] = 'wl-paste',
  },
}

-- vim.g.clipboard = "win32yank"
-- vim.g.clipboard = "osc52"
-- vim.g.clipboard = "wl-copy"
vim.g.mkdp_open_to_the_world = 1
vim.g.autoformat = false
vim.opt.fileencodings = "ucs-bom,utf-8,gbk,default,latin1"
vim.opt.textwidth = 10000
vim.opt.smartindent = true
