return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, 
          ["<C-d>"] = { "<C-d>zz" },
          ["<C-u>"] = { "<C-u>zz" }
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = {
          -- this mapping will only be set in buffers with an LSP attached
          K = {
            function()
              vim.lsp.buf.hover()
            end,
            desc = "Hover symbol details",
          },
        },
      },
    },
  },
}
