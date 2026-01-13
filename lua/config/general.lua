-- Simultanious absoute and relative line numbering.
vim.cmd("set number")

-- Colorscheme
-- Uses environment variable to set background color
kitty_path = "/home/tom/.config/kitty/"
local theme_mode_file = io.open(kitty_path .. "theme_mode.conf", "r")
io.input(theme_mode_file)
if io.read() == "light" then
  vim.o.background = "light"
else
  vim.o.background = "dark"
end
io.close(theme_mode_file)
vim.cmd.colorscheme("gruvbox")

vim.cmd("highlight LineNr guifg=#a0a0a0")

-- Highlights the cursor line when entering insert mode.
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.cmd("set cursorline")
  end,
})
-- Removes cursor highlighting when leaving insert mode.
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.cmd("set nocursorline")
  end,
})

vim.api.nvim_set_hl(0, "VertSplit", { fg = "#458588" }) -- soft blue (same as kitty and tmux themes)
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#458588" }) -- same color for consistency
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#458588" })
vim.cmd("set laststatus=3") -- Makes horizontal split visible. No idea why it works.
vim.o.splitright = true -- Puts new vertical splits on the right side.
vim.o.splitbelow = true -- Puts new horizontal splits on the bottom.

-- Text wrapping and linebreaking
-- Enable linebreak for Markdown and LaTeX files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "tex" },
	callback = function()
		vim.opt_local.linebreak = true -- only for this buffer
		vim.opt_local.wrap = true -- you might want wrap too
	end,
})

-- Code folding
vim.cmd("set foldmethod=indent")
vim.cmd("set foldcolumn=1")
vim.cmd("au BufRead * normal zR") -- Start file with all folds open.

-- Indent size
vim.cmd("set shiftwidth=4")
vim.cmd("set softtabstop=4")
vim.cmd("set tabstop=4")
vim.cmd("set expandtab")

-- Prevent folding in telescope-browser
vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  command = "setlocal nofoldenable",
})

-- Iron keymaps
vim.keymap.set("n", "<leader>xx", "<cmd>IronRunCurrent<cr>")
vim.keymap.set("n", "<leader>xc", "<cmd>IronRunCell<cr>")
