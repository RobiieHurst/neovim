vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "dosini" }, -- .env files are typically detected as 'dosini' filetype
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.env" },
  callback = function()
    vim.b.autoformat = false
  end,
})
