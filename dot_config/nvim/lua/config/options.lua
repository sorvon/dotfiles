-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mkdp_open_to_the_world = 1
vim.g.mkdp_echo_preview_url = 1
vim.g.autoformat = false
vim.opt.fileencodings = "ucs-bom,utf-8,gbk,default,latin1"
vim.opt.textwidth = 300
vim.opt.smartindent = true
vim.opt.expandtab = true
if vim.g.neovide then
  require("config.neovide")
end

vim.g.clipboard_sync_cli_server = vim.fn.getenv("CLIPBOARD_SYNC_CLI_SERVER")
print(vim.g.clipboard_sync_cli_server)
if vim.g.clipboard_sync_cli_server ~= vim.NIL then
  local curl = require("plenary.curl")
  local clipboard_server_connect = true
  local url = "http://" .. vim.g.clipboard_sync_cli_server .. "/clipboard/base64"

  local function clipboard_copy(reg)
    return function(lines)
      local s = table.concat(lines, "\n")
      local success, res = pcall(curl.post, url, {
        body = vim.base64.encode(s),
        timeout = 500,
      })
      if not success or res.status ~= 200 then
        clipboard_server_connect = false
        print("clipboard_server disconnect")
        require("vim.ui.clipboard.osc52").copy(reg)(lines)
      else
        clipboard_server_connect = true
      end
    end
  end

  local function clipboard_paste()
    if not clipboard_server_connect then
      return { vim.fn.getreg('"') }
    end
    local success, res = pcall(curl.get, url, { timeout = 500 })
    if not success or res.status ~= 200 then
      clipboard_server_connect = false
      print("clipboard_server disconnect")
      return { vim.fn.getreg('"') }
    else
      clipboard_server_connect = true
    end
    local content = vim.base64.decode(res.body)
    local lines = vim.split(content, "\n")
    if vim.o.clipboard == "" then
      vim.fn.setreg('"', lines)
    end
    return lines
  end

  vim.g.clipboard = {
    name = "clipboard_sync_cli",
    copy = {
      ["+"] = clipboard_copy("+"),
      ["*"] = clipboard_copy("*"),
    },
    paste = {
      ["+"] = clipboard_paste,
      ["*"] = clipboard_paste,
    },
    cache_enabled = 1,
  }
end
