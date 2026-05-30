return {
  "hrsh7th/cmp-path",
  "saadparwaiz1/cmp_luasnip",
  "L3MON4D3/LuaSnip",

  {
    "github/copilot.vim",
    -- Set lazy to false to ensure Copilot is loaded at startup
    lazy = false,
  },

  -- tool to visualize mermaid diagrams
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown", "mermaid" } -- Add mermaid filetype
    end,
    ft = { "markdown", "mermaid" },
  },

  -- Alacritty + Zellij: no kitty graphics protocol
  {
    "folke/snacks.nvim",
    opts = {
      image = { enabled = false },
      lazygit = { enabled = false },
    },
  },
}
