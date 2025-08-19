---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "query",
      "markdown",
      "markdown_inline",
      "javascript",
      "typescript",
      "python",
      "go",
      "rust", 
      "html",
      "css",
      "json",
      "yaml",
      "toml",
      "bash",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
    },
  },
}
