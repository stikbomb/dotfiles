-- Убираем шум при чтении markdown:
--  * markdownlint гоняем по глобальному «прозаическому» конфигу
--  * заголовки рендерим иконками вместо сырых ##
--  * чекбоксы рендерим
local global_config = vim.fn.expand("~/.config/markdownlint/.markdownlint.yaml")

-- Если у проекта есть свой конфиг — берём его, иначе глобальный.
local function markdownlint_config()
  local found = vim.fs.find({
    ".markdownlint-cli2.jsonc",
    ".markdownlint-cli2.yaml",
    ".markdownlint-cli2.cjs",
    ".markdownlint.jsonc",
    ".markdownlint.json",
    ".markdownlint.yaml",
    ".markdownlint.yml",
  }, { path = vim.api.nvim_buf_get_name(0), upward = true, type = "file" })[1]
  return found or global_config
end

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", markdownlint_config, "-" },
        },
      },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = {
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      checkbox = {
        enabled = true,
      },
    },
  },

  -- LazyVim вешает markdownlint и на none-ls тоже — получается два одинаковых
  -- набора диагностик. Оставляем только nvim-lint (он ходит с нашим конфигом).
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.sources = vim.tbl_filter(function(source)
        return source.name ~= "markdownlint-cli2"
      end, opts.sources or {})
    end,
  },
}
