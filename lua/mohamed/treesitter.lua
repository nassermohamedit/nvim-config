require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "rust", "c", "zig", "go", "python", "lua", "vim", "vimdoc", "markdown", "markdown_inline" },

  sync_install = false,
  auto_install = false,

  -- khkhkhkh tff disguuuuuuuuuuuuuuuusting
  ignore_install = { "javascript" },


  highlight = {
    enable = false,

    additional_vim_regex_highlighting = false,
  },
}


