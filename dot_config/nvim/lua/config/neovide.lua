vim.o.guifont = "Maple Mono NF CN:h12"
vim.g.neovide_scale_factor = 1.0
-- 影响性能
vim.g.neovide_floating_blur = false

local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(1.1)
end)
vim.keymap.set("n", "<C-->", function()
  change_scale_factor(1 / 1.1)
end)
local function save()
  vim.cmd.write()
end
local function copy()
  vim.cmd([[normal! "+y]])
end
local function paste()
  vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
end

vim.keymap.set({ "n", "i", "v" }, "<C-s>", save, { desc = "Save" })
vim.keymap.set("v", "<C-S-c>", copy, { silent = true, desc = "Copy" })
vim.keymap.set({ "n", "i", "v", "c", "t" }, "<C-S-v>", paste, { silent = true, desc = "Paste" })
