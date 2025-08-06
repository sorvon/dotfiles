-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.clipboard = {
  name = "osc52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("+"),
  },
  paste = {
    ["+"] = function()
      local t = require("vim.ui.clipboard.osc52").paste("+")()
      if type(t) == "table" then
        for key, value in pairs(t) do
          t[key] = string.gsub(value, "\r", "")
        end
      end
      return t
    end,
    ["*"] = function()
      local t = require("vim.ui.clipboard.osc52").paste("+")()
      if type(t) == "table" then
        for key, value in pairs(t) do
          t[key] = string.gsub(value, "\r", "")
        end
      end
      return t
    end,
  },
}

if vim.env.ZELLIJ ~= nil then
  vim.g.clipboard = "win32yank"
end
vim.g.mkdp_open_to_the_world = 1
vim.g.autoformat = false
vim.opt.fileencodings = "ucs-bom,utf-8,gbk,default,latin1"
vim.opt.textwidth = 1000
vim.opt.smartindent = true
