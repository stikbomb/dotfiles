return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      -- Fix for LazyVim compatibility with new mason-lspconfig API
      local mason_lspconfig = require("mason-lspconfig")
      if not mason_lspconfig.mappings then
        mason_lspconfig.mappings = {
          get_mason_map = function()
            local server_mappings = require("mason-lspconfig.mappings.server")
            return {
              lspconfig_to_package = server_mappings.lspconfig_to_package,
              package_to_lspconfig = server_mappings.package_to_lspconfig,
            }
          end,
        }
      end
      return opts
    end,
  },
}
