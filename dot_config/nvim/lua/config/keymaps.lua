-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], { desc = "esc t" })
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "wincmd h" })
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "wincmd j" })
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "wincmd k" })
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "wincmd l" })
vim.keymap.set({ "n", "x", "t", "i" }, "<a-s-q>", function()
  local curl = require("plenary.curl")
  curl.post("http://localhost:11457/clipboard/qrcode_show")
end)
local lazygit = require("toggleterm.terminal").Terminal:new({
  id = 99,
  cmd = "lazygit",
  hidden = true,
  close_on_exit = true,
})
vim.keymap.set({ "n", "t" }, "<A-/>", function()
  lazygit.dir = LazyVim.root.git()
  lazygit:toggle()
end, { desc = "Lazygit (Root Dir)" })

local function scope_toggleterm(direction)
  return function()
    local buf_id = vim.api.nvim_get_current_buf()
    local buf_name = vim.api.nvim_buf_get_name(buf_id)
    local offset = vim.api.nvim_get_current_tabpage() * 1000 + vim.v.count
    if string.match(buf_name, "^term://.*#toggleterm#%d+$") then
      vim.cmd(string.format("ToggleTerm direction=%s", direction))
    else
      vim.cmd(string.format('exe %d . "ToggleTerm direction=%s"', offset, direction))
    end
  end
end
local function toggleterm(direction)
  return function()
    if vim.v.count > 0 then
      vim.cmd(string.format('exe %d . "ToggleTerm direction=%s"', direction))
    else
      vim.cmd(string.format("ToggleTerm direction=%s", direction))
    end
  end
end
vim.keymap.set({ "n", "t", "i", "v" }, [[<A-\>]], scope_toggleterm("float"))
vim.keymap.set({ "n", "t", "i", "v" }, [[<C-\>]], scope_toggleterm("vertical"))
vim.keymap.set({ "n", "v" }, [[<leader>t]], toggleterm("tab"))

local term_clear = function()
  vim.fn.feedkeys("^L", "n")
  local sb = vim.bo.scrollback
  vim.bo.scrollback = 1
  vim.bo.scrollback = sb
end

vim.keymap.set("t", "<C-l>", term_clear)

local api = require("remote-sshfs.api")
vim.keymap.set("n", "<leader>rc", api.connect, {})
vim.keymap.set("n", "<leader>rd", api.disconnect, {})
vim.keymap.set("n", "<leader>re", api.edit, {})

-- (optional) Override telescope find_files and live_grep to make dynamic based on if connected to host
local builtin = require("telescope.builtin")
local connections = require("remote-sshfs.connections")
vim.keymap.set("n", "<leader>ff", function()
  if connections.is_connected() then
    api.find_files()
  else
    builtin.find_files()
  end
end, {})
vim.keymap.set("n", "<leader>fg", function()
  if connections.is_connected() then
    api.live_grep()
  else
    builtin.live_grep()
  end
end, {})
