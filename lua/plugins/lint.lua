return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        markdownlint = {
          args = { "--disable", "MD013", "MD031", "MD032", "MD033", "--" },
        },
        ["markdownlint-cli2"] = {
          args = { "--config", "~/.markdownlintrc", "--" },
        },
      },
    },
  },
}
