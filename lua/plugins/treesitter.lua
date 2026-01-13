return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        event = "BufReadPost",
        config = function()
            local treesitter = require("nvim-treesitter")
            treesitter.setup()
            treesitter.install({
                "python",
                "r",
                "haskell",
                "julia",
                "rust",
                "lua",
                "bash",
                "markdown",
                "c",
                "cpp",
                "html",
                "css",
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "python",
                    "r",
                    "haskell",
                    "julia",
                    "rust",
                    "lua",
                    "bash",
                    "markdown",
                    "c",
                    "cpp",
                    "html",
                    "css",
                },
                callback = function()
                    vim.treesitter.start()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
}
