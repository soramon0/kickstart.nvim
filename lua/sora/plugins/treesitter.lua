return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  lazy = false,
  config = function()
    -- The `main` branch rewrite no longer ships modules like `highlight`,
    -- `indent`, or `autotag`. `setup()` only accepts `{ install_dir = ... }`
    -- and any other keys are silently ignored. Keep this minimal.
    require('nvim-treesitter').setup {}

    -- Ensure preferred parsers are installed (async, runs in background).
    require('nvim-treesitter').install {
      'bash',
      'c',
      'cpp',
      'html',
      'lua',
      'markdown',
      'markdown_inline',
      'make',
      'vim',
      'vimdoc',
      'json',
      'javascript',
      'typescript',
      'tsx',
      'python',
    }

    -- The new branch leaves it up to the user to start treesitter for a buffer.
    -- Start highlights, folds, and indents whenever a parser is available.
    vim.api.nvim_create_autocmd({ 'FileType' }, {
      group = vim.api.nvim_create_augroup('sora-treesitter-start', { clear = true }),
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return
        end
        if not pcall(vim.treesitter.start, buf, lang) then
          return
        end
        -- Optional: tree-sitter based folds and indent. Comment out if you
        -- prefer the language's default indentexpr.
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
