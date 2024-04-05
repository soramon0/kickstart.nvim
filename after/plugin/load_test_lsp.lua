local client = vim.lsp.start_client {
  name = 'eductionalsp',
  cmd = { '/home/sora/w/doju/eductionalsp/main' },
}

if not client then
  vim.notify 'hey, you didnt do the client thing well'
  return
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.lsp.buf_attach_client(0, client)
  end,
})
