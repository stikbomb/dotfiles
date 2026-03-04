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
