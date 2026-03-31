return {
  "nanozuki/tabby.nvim",
  ---@type TabbyConfig
  opts = {
    -- configs...
  },
  keys = {
    { "<a-1>", "<esc>1gt", mode = { "n", "i", "x", "t" } },
    { "<a-2>", "<esc>2gt", mode = { "n", "i", "x", "t" } },
    { "<a-3>", "<esc>3gt", mode = { "n", "i", "x", "t" } },
    { "<a-4>", "<esc>4gt", mode = { "n", "i", "x", "t" } },
    { "<a-5>", "<esc>5gt", mode = { "n", "i", "x", "t" } },
    { "<a-6>", "<esc>6gt", mode = { "n", "i", "x", "t" } },
    { "<a-7>", "<esc>7gt", mode = { "n", "i", "x", "t" } },
    { "<a-8>", "<esc>8gt", mode = { "n", "i", "x", "t" } },
    { "<a-9>", "<esc>9gt", mode = { "n", "i", "x", "t" } },
    { "<a-0>", "<cmd>Tabby jump_to_tab<cr>", mode = { "n", "x", "t" } },
    { "<a-s-h>", "<cmd>tabp<cr>", mode = { "n", "x", "t" } },
    { "<a-s-l>", "<cmd>tabn<cr>", mode = { "n", "x", "t" } },
    { "<<", "<cmd>-tabmove<cr>", desc = "Move tab prev" },
    { ">>", "<cmd>+tabmove<cr>", desc = "Move tab next" },
  },
}
