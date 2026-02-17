return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ltex = {
          filetypes = { "markdown" }, -- only markdown
          settings = {
            ltex = {
              language = "en-US",
              enabled = { "markdown" },

              additionalRules = {
                enablePickyRules = true,
              },

              disabledRules = {},

              enabledRules = {
                ["en-US"] = {},
              },

              languageToolHttpServerUri = "https://api.languagetoolplus.com/v2",
              languageToolOrg = {
                username = os.getenv("LT_USERNAME"),
                apiKey = os.getenv("LT_API_KEY"),
              },
            },
          },
        },
      },
    },
  },
}
