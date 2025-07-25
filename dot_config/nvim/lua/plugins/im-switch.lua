if true then return {} end
return {
  { "nvim-lua/plenary.nvim", lazy = true }, -- plenary.nvim is required
  {
    "drop-stones/im-switch.nvim",
    event = "VeryLazy",
    opts = {
      default_im_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },
      save_im_state_events = { "InsertLeavePre" },
      restore_im_events = { "InsertEnter" },
      windows = {
        enabled = true,
      },
    },
  },
}
