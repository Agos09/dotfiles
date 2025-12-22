-- ~/.config/nvim/lua/plugins/oil.lua



return {
  "stevearc/oil.nvim",
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      -- Your setup options here, for example:
      view_options = {
        show_hidden = true,
      },
    })

    -- Set the keymap here
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory with oil.nvim" })
  end,
}
