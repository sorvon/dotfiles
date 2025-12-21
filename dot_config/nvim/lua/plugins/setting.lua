-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "catppuccin",
    opts = {
      background = {
        dark = "macchiato",
      },
    },
  },
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },
  {
    "chrisgrieser/nvim-rip-substitute",
    -- 建议添加 event 或 cmd 触发加载
    event = "VeryLazy",
    cmd = "RipSubstitute",
    keys = {
      -- 将 g/ 映射到 Normal 和 Visual 模式下启动替换
      {
        "g/",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" }, -- n=Normal, x=Visual
        desc = "Rip Substitute (区域/文件替换)",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s", "n" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s", "n" }),
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        prettier_xml = {
          command = "/usr/local/bin/prettier",
          args = { "--plugin==/usr/local/lib/node_modules/@prettier/plugin-xml/src/plugin.js", "--write", "$FILENAME" },
        },
      },
      default_format_opts = {
        timeout_ms = 10000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        -- nu = { "nufmt" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "kdl" } },
  },
  {
    "nmac427/guess-indent.nvim",
    opts = {
      auto_cmd = true,
      on_tab_options = { -- A table of vim options when tabs are detected
        ["expandtab"] = true,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_y, { "encoding" })
      table.insert(opts.sections.lualine_y, {
        function()
          if vim.bo.expandtab then
            return "󱁐 " .. vim.bo.shiftwidth -- 空格图标
          else
            return "⇥ " .. vim.bo.tabstop -- 制表符图标
          end
        end,
        color = { fg = "#FF9E64" }, -- 橙色
        padding = { left = 1 },
        separator = " ",
      })
      table.insert(opts.sections.lualine_y, { "fileformat" })
    end,
  },
  {
    "mistweaverco/kulala.nvim",
    tag = "v5.3.2",
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-h>"] = require("telescope.actions").to_fuzzy_refine, -- 内容搜索过滤
          },
        },
      },
    },
  },
  {
    "yanky.nvim",
    opts = {
      ring = {
        update_register_on_cycle = true,
        permanent_wrapper = require("yanky.wrappers").remove_carriage_return,
      },
      system_clipboard = {
        sync_with_ring = true,
        clipboard_register = "+",
      },
    },
  },
  {
    "gitsigns.nvim",
    opts = {
      max_file_length = 100000,
    },
  },
  {
    "bufferline.nvim",
    keys = {
      { "<<", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { ">>", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
  },
}
