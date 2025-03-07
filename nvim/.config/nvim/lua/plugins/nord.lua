return {
  "nordtheme/vim",
  priority = 1000,
  config = function()
    vim.g.nord_uniform_status_lines = 1
    vim.g.nord_bold_vertical_split_line = 0
    vim.g.nord_borders = true
    vim.cmd.colorscheme 'nord'
  end
}
