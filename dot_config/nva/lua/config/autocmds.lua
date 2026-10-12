-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Отключить автоформатирование для .env файлов
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.env", ".env*" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- LazyVim включает spell для markdown/text — на русском тексте это сплошное
-- красное подчёркивание. Выключаем; <leader>us включает обратно точечно.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.spell = false
  end,
})
