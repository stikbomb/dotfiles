-- -- ~/.config/nvim/lua/plugins/lsp.lua (или другой подходящий путь)
-- return {
--   {
--     "neovim/nvim-lspconfig",
--     opts = {
--       servers = {
--         -- pylsp = {
--         --   settings = {
--         --     pylsp = {
--         --       plugins = {
--         --         rope_autoimport = {
--         --           enabled = true,
--         --           completions = { enabled = true },
--         --           code_actions = { enabled = true },
--         --         },
--         --         -- Другие настройки pylsp (опционально)
--         --         pycodestyle = {
--         --           enabled = false, -- Пример: отключить pycodestyle
--         --           ignore = { "E501" }, -- Игнорировать длину строки и в pycodestyle
--         --           maxLineLength = 999,
--         --         },
--         --       },
--         --     },
--         --   },
--         -- },
--       },
--     },
--   },
-- }
--

return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local linters = require("lint").linters
      if linters["markdownlint-cli2"] then
        linters["markdownlint-cli2"].args = {
          "--config", vim.fn.expand("~/.markdownlint.json"),
          "--",
        }
      end
      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          init_options = {
            settings = {
              format = true, -- Disable Ruff formatting (use conform.nvim)
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                library = {
                  "/home/stik/defold/defold-annotations/", -- путь к аннотациям
                },
              },
              diagnostics = {
                globals = { "go", "vmath", "msg", "timer", "hash", "gui", "render", "sys", "socket", "http" },
              },
            },
          },
        },
      },
    },
  },
}
