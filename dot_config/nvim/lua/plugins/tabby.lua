local compact_tab = false
return {
  "nanozuki/tabby.nvim",
  ---@type TabbyConfig
  opts = {
    option = {
      tab_name = {
        name_fallback = function(tabid)
          local api = require("tabby.module.api")
          local tabno = api.get_tab_number(tabid)
          local cur_tabid = api.get_current_tab()
          if compact_tab and tabid ~= cur_tabid then
            return ""
          end
          local ok, cwd = pcall(vim.fn.getcwd, -1, tabno)
          if ok then
            return vim.fn.fnamemodify(cwd, ":t")
          else
            return "" .. tabid
          end
        end,
      },
    },
    line = function(line)
      local theme = {
        fill = "TabLineFill",
        head = "TabLine",
        current_tab = "TabLineSel",
        tab = "TabLine",
        win = "TabLine",
        tail = "TabLine",
      }
      local tablen = vim.o.columns
      -- head
      tablen = tablen - 3
      -- sep
      tablen = tablen - 1
      local cur_tab_col = 0
      local total_col = 0
      line.tabs().foreach(function(tab)
        -- sep
        total_col = total_col + 1
        -- margin
        total_col = total_col + 1
        -- number
        if tab.in_jump_mode() then
          total_col = total_col + 1
          -- margin
          total_col = total_col + 1
        else
          total_col = total_col + 1
          -- margin
          total_col = total_col + 1
          local number_str = tostring(tab.number())
          total_col = total_col + #number_str
          -- margin
          total_col = total_col + 1
        end
        if tab.is_current() then
          cur_tab_col = total_col
        end
        -- name
        total_col = total_col + #tab.name()
        -- margin
        total_col = total_col + 1
        -- sep
        total_col = total_col + 1
        return {}
      end)
      local col_min = math.floor(cur_tab_col - tablen / 2.0 + 0.5)
      col_min = math.max(1, math.min(total_col - tablen + 1, col_min))
      local col_max = col_min + tablen - 1

      local status_icon = { "", "󰆣" }
      local cur_col = 0
      return {
        {
          { "  ", hl = theme.head },
          line.sep("", theme.head, theme.fill),
          line.tabs().foreach(function(tab)
            if cur_col > col_max then
              return {}
            end
            local hl = tab.is_current() and theme.current_tab or theme.tab
            local res = { hl = hl, margin = " " }
            -- sep
            cur_col = cur_col + 1
            if cur_col >= col_min and cur_col <= col_max then
              res[#res + 1] = line.sep("", hl, theme.fill)
            end
            -- margin
            cur_col = cur_col + 1
            -- number
            if tab.in_jump_mode() then
              cur_col = cur_col + 1
              if cur_col >= col_min and cur_col <= col_max then
                res[#res + 1] = tab.jump_key()
              end
              -- margin
              cur_col = cur_col + 1
            else
              local sub_res = { margin = " " }
              cur_col = cur_col + 1
              if cur_col >= col_min and cur_col <= col_max then
                sub_res[#sub_res + 1] = tab.is_current() and status_icon[1] or status_icon[2]
              end
              -- margin
              cur_col = cur_col + 1
              local number_str = tostring(tab.number())
              cur_col = cur_col + #number_str
              if cur_col >= col_min and cur_col <= col_max then
                sub_res[#sub_res + 1] = tab.number()
              end
              if #sub_res > 0 then
                res[#res + 1] = sub_res
              end
              -- margin
              cur_col = cur_col + 1
            end
            -- name
            local name = tab.name()
            local name_begin = cur_col + 1
            local name_end = cur_col + #name
            local i = math.max(name_begin, col_min) - name_begin + 1
            local j = math.min(name_end, col_max) - name_begin + 1
            cur_col = name_end
            if i < j then
              cur_col = math.min(name_end, col_max)
              res[#res + 1] = name:sub(i, j)
            end
            -- margin
            cur_col = cur_col + 1
            -- sep
            cur_col = cur_col + 1
            if cur_col >= col_min and cur_col <= col_max then
              res[#res + 1] = line.sep("", hl, theme.fill)
            end
            return res
          end),
          hl = theme.fill,
        },
      }
    end,
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
    { "<a-0>", "<cmd>Tabby jump_to_tab<cr>", mode = { "n", "i", "x", "t" } },
    {
      "<a-->",
      function()
        compact_tab = not compact_tab
        vim.cmd("redrawtabline")
      end,
      mode = { "n", "i", "x", "t" },
    },
    {
      "<a-`>",
      function()
        local tab_last = vim.fn.tabpagenr("#")
        vim.cmd("tabnext " .. tab_last)
      end,
      mode = { "n", "i", "x", "t" },
    },
    { "<a-s-h>", "<cmd>tabp<cr>", mode = { "n", "i", "x", "t" } },
    { "<a-s-l>", "<cmd>tabn<cr>", mode = { "n", "i", "x", "t" } },
    { "<<", "<cmd>-tabmove<cr>", desc = "Move tab prev" },
    { ">>", "<cmd>+tabmove<cr>", desc = "Move tab next" },
  },
}
