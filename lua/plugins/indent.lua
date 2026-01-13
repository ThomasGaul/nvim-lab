return {
  {
    'nvimdev/indentmini.nvim',
    event = 'BufEnter',
    config = function()
      vim.cmd('hi default link IndentLine Comment')
      require('indentmini').setup({
        only_current = false,
      })
    end,
  }
}

