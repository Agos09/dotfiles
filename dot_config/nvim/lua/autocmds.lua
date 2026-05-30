-- Create a group so autocmds don't double-up on config reload
local function augroup(name) return vim.api.nvim_create_augroup("lazy_chezmoi_" .. name, { clear = true }) end

-- 1. SYNC LAZY-LOCK TO CHEZMOI
-- Automatically runs 'chezmoi add' whenever lazy.nvim updates plugins
vim.api.nvim_create_autocmd("User", {
  group = augroup "chezmoi_sync",
  pattern = "LazyUpdate",
  callback = function()
    local lockfile = vim.fn.stdpath "config" .. "/lazy-lock.json"
    -- Check if we are actually in a chezmoi managed environment
    vim.fn.jobstart({ "chezmoi", "add", lockfile }, {
      on_exit = function(id, code)
        if code == 0 then
          vim.notify("Chezmoi: lazy-lock.json updated", vim.log.levels.INFO)
        else
          vim.notify("Chezmoi: Failed to update lockfile", vim.log.levels.ERROR)
        end
      end,
    })
  end,
})

-- 2. AUTO-RELOAD FILES
-- Triggered when a file changes outside of Neovim (e.g., via git or chezmoi apply)
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup "checktime",
  command = "checktime",
})

-- 3. HIGHLIGHT ON YANK
-- Briefly highlight text when you copy (yank) it
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup "highlight_yank",
  callback = function() vim.hl.on_yank { timeout = 200 } end,
})

-- 4. GO TO LAST LOC
-- Go to the last cursor location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup "last_loc",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})
