-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Автоматически переключать на английский при выходе из режима вставки
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    -- vim.fn.system("setxkbmap -layout us")  -- Linux (X11)
    -- Для Wayland:
    vim.fn.system("swaymsg input type:keyboard xkb_layout us")
  end,
})
vim.hl = vim.highlight

vim.filetype.add({
  extension = {
    script = "lua",
  },
})
