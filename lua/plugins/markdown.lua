return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
      linters = {
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            vim.fn.expand("~/.config/nvim/.markdownlint-cli2.jsonc"),
            "--",
          },
        },
      },
    },
  },
}
