-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.clipboard = {
  name = 'WslClipboard',
  copy = {
    ["+"] = { "nvim-clip", "set" },
    ["*"] = { "nvim-clip", "set" }
  },
  paste = {
    ["+"] = { "nvim-clip", "get" },
    ["*"] = { "nvim-clip", "get" }
  },
}
-- vim.g.clipboard = {
--   name = 'xsel',
--   copy = {
--     ["+"] = function (line)
--       require('vim.ui.clipboard.osc52').copy('+')(line)
--       vim.system({"xsel", "-i"}, {stdin=line})
--     end,
--     ["*"] = function (line)
--       require('vim.ui.clipboard.osc52').copy('+')(line)
--       vim.system({"xsel", "-i"}, {stdin=line})
--     end,
--   },
--   paste = {
--     ["+"] = { "xsel", "-o" },
--     ["*"] = { "xsel", "-o" }
--   },
--   cache_enabled = 1,
-- }
-- vim.g.clipboard = "win32yank"
-- vim.g.clipboard = "xsel"
-- vim.g.clipboard = "xclip"
-- vim.g.clipboard = "osc52"
vim.g.mkdp_open_to_the_world = 1
vim.g.autoformat = false
vim.opt.fileencodings = "ucs-bom,utf-8,gbk,default,latin1"
vim.opt.textwidth = 10000
vim.opt.smartindent = true
