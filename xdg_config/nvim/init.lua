if vim.env.NVIM_NEW_CONFIG ~= nil then
  require('beaver')
else
  require('bv11').setup()
end
