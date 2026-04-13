return {
  "nanozuki/tabby.nvim",
  ---@type TabbyConfig
  opts = {
    option = {
      tab_name = {
        name_fallback = function(tabid)
          return tabid
        end,
        override = function(tabid)
          return vim.fn.fnamemodify(vim.fn.getcwd(-1, tabid), ':t')
        end,
      },
    }
  },
  keys = {
    { "<a-1>", "<cmd>tabnext 1<cr>", mode = { "n", "i", "x", "t" } },
    { "<a-2>", "<cmd>tabnext 2<cr>", mode = { "n", "i", "x", "t" } },
    { "<a-3>", "<cmd>tabnext 3<cr>", mode = { "n", "i", "x", "t" } },
    { "<a-4>", "<cmd>tabnext 4<cr>", mode = { "n", "i", "x", "t" } },
    { "<a-5>", "<cmd>tabnext 5<cr>", mode = { "n", "i", "x", "t" } },
    { "<a-6>", "<cmd>tabnext 6<cr>", mode = { "n", "i", "x", "t" } },
    { "<a-7>", "<cmd>tabnext 7<cr>", mode = { "n", "i", "x", "t" } },
    { "<a-8>", "<cmd>tabnext 8<cr>", mode = { "n", "i", "x", "t" } },
    { "<a-9>", "<cmd>tabnext 9<cr>", mode = { "n", "i", "x", "t" } },
    { "<a-0>", "<cmd>Tabby jump_to_tab<cr>", mode = { "n", "x", "t" } },
    { "<a-s-h>", "<cmd>tabp<cr>", mode = { "n", "x", "t" } },
    { "<a-s-l>", "<cmd>tabn<cr>", mode = { "n", "x", "t" } },
    { "<<", "<cmd>-tabmove<cr>", desc = "Move tab prev" },
    { ">>", "<cmd>+tabmove<cr>", desc = "Move tab next" },
  },
}
