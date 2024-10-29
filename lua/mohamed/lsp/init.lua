local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "mohamed.lsp.mason"
require("mohamed.lsp.handlers").setup()
require "mohamed.lsp.null-ls"
