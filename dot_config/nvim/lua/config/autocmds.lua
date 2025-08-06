-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("dyh", { clear = true }),
  callback = function()
    if vim.bo.fileencoding == "" and vim.api.nvim_buf_get_name(0) ~= "" then
      vim.cmd("edit ++enc=cp936")
    end
  end
})
