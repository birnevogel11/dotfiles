return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = { adapter = "gemma3" },
        inline = { adapter = "gemma3" },
        cmd = { adapter = "gemma3" },
      },
      adapters = {
        gemma3 = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "gemma3",
            schema = {
              default = "gemma3:12b",
            },
            env = {
              url = "http://192.168.178.45:11434",
            },
          })
        end
      }
    })
  end
}
