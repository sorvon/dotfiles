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
        vim.cmd("w")
        vim.defer_fn(function()
          require("code_runner").run_code()
        end, 100)
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
          return "/mnt/c/Users/dingyh54129/AppData/Local/Programs/Python/Python314/python.exe -u"
        end
      end,
      nu = "nu",
      sh = "bash",
      typescript = "deno run",
      typescriptreact = "yarn dev$end",
      rust = "cd $dir ; rustc $fileName ; $dir$fileNameWithoutExt",
      http = function()
        require("kulala").run()
      end,
      hurl = function()
        local utils = require("hurl.utils")
        local http = require("hurl.http_utils")
        local hurl_runner = require("hurl.lib.hurl_runner")
        local result = http.find_hurl_entry_positions_in_buffer()
        if result.current > 0 and result.start_line and result.end_line then
          utils.log_info("hurl: running request at line " .. result.start_line .. " to " .. result.end_line)
          local bufnr = vim.api.nvim_get_current_buf()
          local lines = vim.api.nvim_buf_get_lines(bufnr, result.start_line - 1, result.end_line, false)
          local filtered_lines = {}
          for _, line in ipairs(lines) do
            local cmd = line:match('^#%s*cmd:%s*"([^"]+)"')
            if cmd then
              vim.fn.system(cmd)
            end
            if not line:match("^%s*#") then
              table.insert(filtered_lines, line)
            end
          end
          local fname = utils.create_tmp_file(filtered_lines)
          if not fname then
            utils.log_warn("hurl: create tmp file failed")
            utils.notify("hurl: create tmp file failed. Please try again!", vim.log.levels.WARN)
            return
          end
          local opts = {}
          table.insert(opts, fname)
          hurl_runner.execute_hurl_cmd(opts)
          -- Clean up the temporary file after a delay
          local timeout = 1000
          vim.defer_fn(function()
            local success = os.remove(fname)
            if not success then
              utils.log_info("hurl: remove file failed " .. fname)
              utils.notify("hurl: remove file failed", vim.log.levels.WARN)
            else
              utils.log_info("hurl: remove file success " .. fname)
            end
          end, timeout)
        else
          utils.log_info("hurl: not HTTP method found in the current line" .. result.start_line)
          utils.notify("hurl: no HTTP method found in the current line", vim.log.levels.INFO)
        end
      end,
    },
    -- project_path = vim.fn.expand("~/.config/nvim/project_manager.json"),
  },
}
