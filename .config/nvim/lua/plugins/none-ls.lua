-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  opts = function(_, opts)
    -- opts variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

    -- Only insert new sources, do not replace the existing ones
    -- (If you wish to replace, use `opts.sources = {}` instead of the `list_insert_unique` function)
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- Set a formatter
      null_ls.builtins.formatting.stylua,
      require "none-ls.diagnostics.eslint",
      require "none-ls.code_actions.eslint",
      null_ls.builtins.formatting.prettier.with {
        condition = function(utils)
          return utils.root_has_file {
            ".prettierrc",
            ".prettierrc.js",
            ".prettierrc.json",
            ".prettierrc.toml",
            ".prettierrc.yaml",
            ".prettierrc.yml",
          }
        end,
      },
      null_ls.builtins.formatting.biome.with {
        condition = function(utils) return utils.root_has_file "biome.json" end,
      },
    })
  end,
}
