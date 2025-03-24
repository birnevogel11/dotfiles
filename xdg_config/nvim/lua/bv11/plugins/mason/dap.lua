local M = {}

M.setup = function()
  require("mason-nvim-dap").setup({
    ensure_installed = {
      "bash",
      -- required packages:
      --     sudo apt install -y gdb libc++-dev libc++abi-dev libstdc++-12-dev
      "codelldb", -- C/C++/Rust
      "cppdbg", -- C/C++
      -- "haskell",
    },
    automatic_installation = true,
    handlers = {
      function(config)
        require('mason-nvim-dap').default_setup(config)
      end
    }
  })
end

return M
