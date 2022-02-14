require'nvim-treesitter.configs'.setup {
  ensure_installed = {"c", "cpp", "cmake", "comment", "css", "dockerfile", "javascript", "json", "html", "go", "graphql", "lua", "python", "typescript", "tsx", "vim", "vue", "yaml"},

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
