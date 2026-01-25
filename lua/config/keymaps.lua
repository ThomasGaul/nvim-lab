-- Various navigation utilities
-- Open Oil in current directory.
-- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Oil in current directory" })

-- Open Telescope file browser
vim.keymap.set(
    "n",
    "<leader>fb",
    "<CMD>Telescope file_browser hidden=true<CR>",
    { desc = "Toggle Nvim Tree Sidebar" }
)

-- Open Telescope bibliography
vim.keymap.set(
    "n",
    "<localleader>b",
    "<CMD>Telescope bibtex<CR>",
    { desc = "Open Telescope bibliography" }
)

-- Keybinding to format the current buffer
vim.keymap.set("n", "<leader>ff", "<CMD>Format<CR>", {
    desc = "format the current buffer using a formatter determined by filetype",
    noremap = true,
    silent = true,
})

-- keybinding to refactor name
vim.keymap.set("n", "<localleader>r", function()
    local cmdId
    cmdId = vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
        callback = function()
            local key = vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
            vim.api.nvim_feedkeys(key, "c", false)
            vim.api.nvim_feedkeys("0", "n", false)
            cmdId = nil
            return true
        end,
    })
    vim.lsp.buf.rename()
    vim.defer_fn(function()
        if cmdId then
            vim.api.nvim_del_autocmd(cmdId)
        end
    end, 800)
end, { desc = "Rename symbol" })

-- Iron-specific keybindings
vim.keymap.set("n", "<leader>xx", "<cmd>IronRunCurrent<cr>")
vim.keymap.set("n", "<leader>xc", "<cmd>IronRunCell<cr>")

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]]) -- Keybinding for escaping terminal mode

-- Keybinding for going to definition and declaration
vim.keymap.set(
    "n",
    "gd",
    "<cmd>lua vim.lsp.buf.declaration()<CR>",
    { noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "gD",
    "<cmd>lua vim.lsp.buf.definition()<CR>",
    { noremap = true, silent = true }
)

-- Keybinding for showing hover documentation
vim.keymap.set(
    "n",
    "K",
    "<cmd>lua vim.lsp.buf.hover()<CR>",
    { noremap = true, silent = true }
)

-- Go to the next diagnostic (error, warning, etc.)
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = false })
end, { noremap = true, silent = true })
-- Go to the previous diagnostic (error, warning, etc.)
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = false })
end, { noremap = true, silent = true })
-- Show diagnostics for the current line (popup window)
vim.keymap.set(
    "n",
    "gl",
    "<cmd>lua vim.diagnostic.open_float()<CR>",
    { noremap = true, silent = true }
)
-- Show all diagnostics in the current buffer
vim.keymap.set(
    "n",
    "<leader>dl",
    "<cmd>lua vim.diagnostic.setloclist()<CR>",
    { noremap = true, silent = true }
)

-- Molten Keymaps
vim.keymap.set(
    "n",
    "<localleader>e",
    ":MoltenEvaluateOperator<CR>",
    { silent = true, desc = "Evaluate operator" }
)
vim.keymap.set("n", "<localleader>mk", function()
    local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
    if venv ~= nil then
        -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
        venv = string.match(venv, "/.+/(.+)")
        vim.cmd(("MoltenInit %s"):format(venv))
    else
        vim.cmd("MoltenInit base")
    end
end, { desc = "Initialize Molten for base", silent = true })

-- Keymaps for light and dark backgrounds
function change_theme_mode(mode)
    local file = io.open(kitty_path .. "theme_mode.conf", "r")
    local fileContent = {}
    for line in file:lines() do
        table.insert(fileContent, line)
    end
    io.close(file)

    fileContent[1] = mode

    file = io.open(kitty_path .. "theme_mode.conf", "w")
    for index, value in ipairs(fileContent) do
        file:write(value .. "\n")
    end
    io.close(file)

    vim.o.background = mode

    if mode == "dark" then
        os.execute(
            "kitten @ --to unix:/tmp/mykitty set-colors -a "
                .. kitty_path
                .. "kitty_themes/"
                .. fileContent[2]
                .. ".conf"
        )
    elseif mode == "light" then
        os.execute(
            "kitten @ --to unix:/tmp/mykitty set-colors -a "
                .. kitty_path
                .. "kitty_themes/"
                .. fileContent[3]
                .. ".conf"
        )
    end
end
vim.keymap.set("n", "<leader>bd", function()
    change_theme_mode("dark")
    vim.o.background = "dark"
end, { desc = "Set background to dark" })
vim.keymap.set("n", "<leader>bl", function()
    change_theme_mode("light")
    vim.o.background = "light"
end, { desc = "Set background to light" })

-- Keymaps to split neovim buffer (separate from tmux split)
vim.keymap.set("n", "<C-w>-", "<CMD>sp<CR>", { desc = "Horizontal split current buffer" })
vim.keymap.set("n", "<C-w>\\", "<CMD>vs<CR>", { desc = "Vertical split current buffer" })

-- Keymaps to resize neovim pane
vim.keymap.set(
    "n",
    "<C-left>",
    "<CMD>vertical resize -2<CR>",
    { desc = "decrease pane size vertically" }
)
vim.keymap.set(
    "n",
    "<C-right>",
    "<CMD>vertical resize +2<CR>",
    { desc = "increase pane size vertically" }
)
vim.keymap.set(
    "n",
    "<C-down>",
    "<CMD>horizontal resize -2<CR>",
    { desc = "decrease pane size horizontally" }
)
vim.keymap.set(
    "n",
    "<C-up>",
    "<CMD>horizontal resize +2<CR>",
    { desc = "increase pane size horizontally" }
)

-- Keymap to clear highlight after search
vim.keymap.set("n", "<localleader>n", "<CMD>noh<CR>", { desc = "clear search highlight" })

-- Keymaps to rotate panes with ventana.nvim
vim.keymap.set(
    "n",
    "<C-w>t",
    "<CMD>VentanaTranspose<CR>",
    { desc = "flip windows along diagonal" }
)
vim.keymap.set(
    "n",
    "<C-w>r",
    "<CMD>VentanaShift<CR>",
    { desc = "shift top level splits" }
)
vim.keymap.set(
    "n",
    "<C-w>l",
    "<CMD>VentanaShiftMaintainLinear<CR>",
    { desc = "rotate buffers in linear layout" }
)

-- move lines but keep the cursor centered
vim.keymap.set("n", "<PageUp>", "<C-u>", { desc = "page up and center cursor" })
vim.keymap.set("n", "<PageDown>", "<C-d>", { desc = "page up and center cursor" })
-- same in insert mode
vim.keymap.set("i", "<PageUp>", "<C-o><C-u>", { desc = "page up and center cursor" })
vim.keymap.set("i", "<PageDown>", "<C-o><C-d>", { desc = "page up and center cursor" })

-- -- Keymaps to move between display lines but keep the cursor centered
vim.keymap.set("n", "<up>", "gk", { desc = "move up a display line" })
vim.keymap.set("n", "<down>", "gj", { desc = "move down a display line" })
-- same in visual mode (except cursor doesn't need to be centered here)
vim.keymap.set("v", "<up>", "gk", { desc = "move up a display line" })
vim.keymap.set("v", "<down>", "gj", { desc = "move down a display line" })
-- same in insert mode
vim.keymap.set("i", "<up>", "<ESC>gki", { desc = "move up a display line" })
vim.keymap.set("i", "<down>", "<ESC>gji", { desc = "move down a display line" })

-- Kepmaps for quickfix
vim.keymap.set("n", "<localleader>qo", "<CMD>copen<CR>", { desc = "Open quickfix menu" })
vim.keymap.set(
    "n",
    "<localleader>qc",
    "<CMD>cclose<CR>",
    { desc = "Close quickfix menu" }
)

-- Keymaps for Vimtex
vim.keymap.set(
    "n",
    "<localleader>vc",
    "<CMD>VimtexCompile<CR>",
    { desc = "Compile with Vimtex" }
)
vim.keymap.set(
    "n",
    "<localleader>vx",
    "<CMD>VimtexClean<CR>",
    { desc = "Clean auxilliary files from LaTeX compilation" }
)
vim.keymap.set(
    "n",
    "<localleader>vq",
    "<CMD>VimtexStop<CR>",
    { desc = "Stop Vimtex compilation" }
)

-- Keymap for toggling text wrapping
vim.keymap.set(
    "n",
    "<localleader>w",
    "<CMD>set wrap!<CR>",
    { desc = "Toggle text wrapping" }
)

-- Keymap for changing vim directory to buffer
vim.keymap.set(
    "n",
    "<leader>cd",
    "<CMD>cd %:h<CR>",
    { desc = "change working directory to parent of current buffer" }
)

-- MarkdownPreviewToggle Keymap
vim.keymap.set(
    "n",
    "<leader>mp",
    "<CMD>MarkdownPreviewToggle<CR>",
    { desc = "Toggle the markdown preview window" }
)

-- Keymap for generating javadocs
vim.keymap.set(
    "n",
    "<localleader>doc",
    "<CMD>Neogen<CR>",
    { desc = "Generate documentation for object under cursor" }
)

-- Keymaps for toggling ltex-ls
vim.keymap.set(
    "n",
    "<leader>le",
    "<CMD>LspStart ltex<CR>",
    { desc = "Enable ltex-ls in current buffer" }
)
vim.keymap.set(
    "n",
    "<leader>ld",
    "<CMD>LspStop ltex<CR>",
    { desc = "Disable ltex-ls in current buffer" }
)

-- Keymaps for toggling python linting
vim.keymap.set(
    "n",
    "<leader>pd",
    "<CMD>LspStop ruff<CR><CMD>LspStop pylsp<CR>",
    { desc = "Disable python linting in current buffer" }
)
vim.keymap.set(
    "n",
    "<leader>pe",
    "<CMD>LspStart ruff<CR><CMD>LspStart pylsp<CR>",
    { desc = "Enable python linting in current buffer" }
)
