return {
  "CRAG666/code_runner.nvim",
  event = "VeryLazy",
  -- name = "code_runner",
  cmd = { "RunCode", "RunFile", "RunProject" },
  -- dev = true,
  keys = {
    {
      "<leader>rr",
      function()
        require("code_runner").run_code()
      end,
      desc = "[e]xcute code",
    },
  },
  opts = {
    mode = "toggleterm",
    filetype = {
      v = "v run",
      quarto = {
        "cd $dir ;",
        "quarto preview $fileName",
        "--no-browser",
        "--port 4444",
      },
      javascript = "node",
      java = "cd $dir ; javac $fileName ; java $fileNameWithoutExt",
      kotlin = "cd $dir ; kotlinc-native $fileName -o $fileNameWithoutExt ; ./$fileNameWithoutExt.kexe",
      c = function(...)
        c_base = {
          "cd $dir ;",
          "gcc $fileName -o",
          "/tmp/$fileNameWithoutExt",
        }
        local c_exec = {
          "; /tmp/$fileNameWithoutExt ;",
          "rm /tmp/$fileNameWithoutExt",
        }
        vim.ui.input({ prompt = "Add more args:" }, function(input)
          c_base[4] = input
          require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
        end)
      end,
      -- cpp = {
      --   'cd $dir ;',
      --   'g++ $fileName',
      --   '-o /tmp/$fileNameWithoutExt ;',
      --   '/tmp/$fileNameWithoutExt',
      -- },
      cpp = function(...)
        cpp_base = {
          [[cd  $dir ;]],
          "g++ $fileName -o",
          "/tmp/$fileNameWithoutExt",
        }
        local cpp_exec = {
          "; /tmp/$fileNameWithoutExt ;",
          "rm /tmp/$fileNameWithoutExt",
        }
        vim.ui.input({ prompt = "Add more args:" }, function(input)
          cpp_base[4] = input
          vim.print(vim.tbl_extend("force", cpp_base, cpp_exec))
          require("code_runner.commands").run_from_fn(vim.list_extend(cpp_base, cpp_exec))
        end)
      end,
      python = function()
        -- 获取当前 buffer 所有内容
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local content = table.concat(lines, "\n")

        -- 使用 vim.fn.matchstr 进行正则匹配（使用 Vim 正则语法）
        local matched_text = vim.fn.matchstr(content, "\\vimport xlwings")
        if matched_text == "" then
          return "uv run"
        else
          return "python.exe -u"
        end
      end,
      nu = "nu",
      sh = "bash",
      typescript = "deno run",
      typescriptreact = "yarn dev$end",
      rust = "cd $dir ; rustc $fileName ; $dir$fileNameWithoutExt",
      http = function ()
        require('kulala').run()
      end
    },
    -- project_path = vim.fn.expand("~/.config/nvim/project_manager.json"),
  },
}
