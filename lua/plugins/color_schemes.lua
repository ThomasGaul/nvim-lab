return {
        {
                "thesimonho/kanagawa-paper.nvim",
                lazy = false,
                -- priority = 1000,
                init = function()
                        vim.cmd.colorscheme("kanagawa-paper-ink")
                end,
                integrations = {
                        wezterm = {
                                enabled = true,
                                path = (os.getenv("TEMP") or "/tmp")
                                        .. "/nvim-theme",
                        },
                },
                opts = { ... },
        },
        {
                "ellisonleao/gruvbox.nvim",
                priority = 1000,
                config = function()
                        require("gruvbox").setup({
                                terminal_colors = true,
                                bold = true,
                                italic = {
                                        strings = false,
                                        comments = false,
                                },
                                contrast = "hard",
                                palette_overrides = {
                                        light1 = "#cdbf9c",
                                },
                        })
                        -- set background specific contrast when added
                        vim.cmd.colorscheme("gruvbox")
                end,
        },
}
