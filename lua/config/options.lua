-- make mode changes faster
vim.opt.ttimeoutlen = 0

-- markdown-preview.nvim options
vim.g.mkdp_refresh_slow = 1
vim.g.mkdp_browser = '/home/tom/zen/zen'

-- Allows VimTeX formatting
vim.g.vimtex_format_enabled = 1

-- make .bashrc available in neovim shell
vim.cmd("set shellcmdflag=-lc")

-- show diagnostics inline
vim.diagnostic.enable()
vim.diagnostic.config({
    virtual_lines = true,
})

-- always point to base python3
vim.g.python3_host_prog = "~/anaconda3/bin/python3"

-- disable providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
