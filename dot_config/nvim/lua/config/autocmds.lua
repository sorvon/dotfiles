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
    if (vim.bo.fileencoding == "" or vim.bo.fileencoding == "latin1") and vim.api.nvim_buf_get_name(0) ~= "" then
      vim.cmd("edit ++enc=cp936")
    end
  end,
})

vim.api.nvim_create_autocmd("TabClosedPre", {
  group = vim.api.nvim_create_augroup("dyh", { clear = true }),
  callback = function()
    local tab_id = vim.api.nvim_get_current_tabpage()
    local api = require("toggleterm.terminal")
    local term_list = api.get_all(true)
    for _, term in ipairs(term_list) do
      local term_tab_id = math.floor(term.id / 1000)
      if tab_id == term_tab_id then
        print("close term_id =", term.id)
        term:shutdown()
      end
    end
  end,
})

vim.api.nvim_create_user_command("TermCloseAll", function()
  local api = require("toggleterm.terminal")
  local term_list = api.get_all(true)
  for _, term in ipairs(term_list) do
    print("close term_id =", term.id)
    term:shutdown()
  end
end, {})
