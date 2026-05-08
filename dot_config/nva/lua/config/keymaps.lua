-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function nmap(shortcut, command, desc, opts)
  opts = opts or { noremap = true, desc = desc }
  vim.api.nvim_set_keymap("n", shortcut, command, opts)
end

local function vmap(shortcut, command, desc, opts)
  opts = opts or { noremap = true, desc = desc }
  vim.api.nvim_set_keymap("v", shortcut, command, opts)
end

nmap("gh", "0", "start of line")
nmap("gl", "$", "end of line")
nmap("gs", "_", "start of text")
nmap("ge", "G")
vmap("gh", "0", "start of line")
vmap("gl", "$", "end of line")
vmap("gs", "_", "start of text")
vmap("ge", "G")

vmap("n", "F12", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

vim.keymap.set("n", "<F12>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

vim.keymap.set("t", "<F12>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

-- Auto-import: удаляет слово под курсором и вставляет заново,
-- открывает LSP omnifunc completion для выбора варианта с импортом
vim.keymap.set("n", "<leader>ci", function()
  local word = vim.fn.expand("<cword>")
  if word == "" then return end
  local keys = vim.api.nvim_replace_termcodes("ciw" .. word, true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
  vim.defer_fn(function()
    -- C-x C-o = omnifunc (LSP) completion, показывает только LSP-варианты с auto-import
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true),
      "i", false
    )
  end, 100)
end, { desc = "Re-trigger auto-import completion" })
