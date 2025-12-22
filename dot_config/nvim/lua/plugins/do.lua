return {
  "nocksock/do.nvim", -- Use the widely available public repo
  event = "VeryLazy",
  config = function()
    require("do").setup {
      winbar = true, -- This is a popular feature of this plugin
    }
  end,
}
