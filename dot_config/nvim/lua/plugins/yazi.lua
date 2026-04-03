---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<leader>-",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      -- Open in the current working directory
      "<leader>cw",
      function()
        require("yazi").yazi(nil, LazyVim.root())
      end,
      desc = "Open the file manager in nvim's working directory",
    },
    {
      "<c-y>",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      change_working_directory = false,
    },
    set_keymappings_function = function(yazi_buffer_id, config, context)
      vim.keymap.set({ "t" }, "<c-p>", function()
        local last_directory = context.ya_process.cwd
        if not last_directory then
          assert(context.input_path, "No input_path found. Expected yazi to be started with an input_path")
          if context.input_path:is_file() then
            last_directory = context.input_path:parent().filename
          else
            last_directory = context.input_path.filename
          end
        end

        if last_directory ~= vim.fn.getcwd() then
          vim.notify('tab cwd changed to "' .. last_directory .. '"')
          vim.cmd({ cmd = "tcd", args = { last_directory } })
        end
      end, { buffer = yazi_buffer_id })
    end,
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}
