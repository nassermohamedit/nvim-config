require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "java", "rust", "c", "zig", "go", "python", "lua", "vim", "vimdoc", "markdown", "markdown_inline" },

  sync_install = false,
  auto_install = true,

  -- khkhkhkh tff disguuuuuuuuuuuuuuuusting
  ignore_install = { "javascript" },


  highlight = {
    enable = true,

    additional_vim_regex_highlighting = false,
  },
}


