-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
  -- { import = "astrocommunity.completion.cmp-tabby" }, -- Example
  { import = "astrocommunity.pack.python" }, -- Add this line
  { import = "astrocommunity.editing-support.zen-mode-nvim" }, -- Optional: for focused writing
  { import = "astrocommunity.media.image-nvim" },
}
