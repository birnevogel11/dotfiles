local M = {}

M.setup = function()
  local default_setup = require("mason-nvim-dap").default_setup

  require("mason-nvim-dap").setup({
    ensure_installed = {
      "bash",
      -- required packages:
      --     sudo apt install -y gdb libc++-dev libc++abi-dev libstdc++-12-dev
      "codelldb", -- C/C++/Rust
      "cppdbg", -- C/C++
      -- "haskell",
    },
    handlers = {
      cppdbg = function(config)
        default_setup(config)
      end,
      bash = function(config)
        default_setup(config)
      end,
      codelldb = function(config)
        default_setup(config)
      end,
    },
  })
end

return M
