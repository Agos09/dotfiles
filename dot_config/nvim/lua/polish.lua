-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Disable optional providers we don't use (silences :checkhealth warnings)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.copilot_no_startup_warnings = 1

-- Set Vim options
vim.opt.wrap = true       -- Enable soft-wrapping
vim.opt.linebreak = true  -- Wrap at word boundaries

require "autocmds"
