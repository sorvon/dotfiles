return {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
  opts = {
    direction = "float",
    shell = "nu",
    close_on_exit = false,
    auto_scroll = false,
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
  },
}
