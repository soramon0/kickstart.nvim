return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    local ts = require 'nvim-treesitter'

    ts.setup {
      -- Module-specific settings (like autotag) go here
      autotag = { enable = true },
    }

    -- Ensure your preferred parsers are installed
    ts.install {
      'bash',
      'c',
      'cpp',
      'html',
      'lua',
      'markdown',
      'vim',
      'vimdoc',
      'json',
      'javascript',
      'typescript',
      'tsx',
      'python',
    }

    -- 🚨 THIS IS THE MISSING PIECE 🚨
    -- This tells Neovim: "Every time I open a file, try to start Treesitter"
    vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        -- Only start if a Treesitter parser exists for this filetype
        local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
        if lang then
          pcall(vim.treesitter.start, buf, lang)
        end
      end,
    })
  end,
}
