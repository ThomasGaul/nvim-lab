return {
    {
        "neovim/nvim-lspconfig",
        ft = {
            "python",
            "r",
            "julia",
            "rust",
            "lua",
            "latex",
            "octave",
            "haskell",
            "c",
            "cpp",
            "tex",
            "markdown",
        },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp", -- 👈 required for completion capabilities
        },
        config = function()
            -- Setup Mason
            require("mason").setup()

            -- Add nvim-cmp completion capabilities to all LSPs
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Function that tells us when LSP is attached.
            local on_attach = function(client, bufnr)
                local bufopts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
                vim.notify("LSP attached: " .. client.name, vim.log.levels.INFO)
            end

            -- Configure LSP servers using new vim.lsp.config API
            vim.lsp.config("ruff", {
                cmd = { "ruff", "server" },
                root_markers = {
                    "pyproject.toml",
                    "setup.py",
                    "setup.cfg",
                    "requirements.txt",
                    ".git",
                },
                capabilities = capabilities,
                on_attach = on_attach,
                init_options = {
                    settings = {
                        configurationPreference = "filesystemFirst",
                    },
                },
            })

            vim.lsp.config("pylsp", {
                cmd = { "pylsp" },
                root_markers = {
                    "pyproject.toml",
                    "setup.py",
                    "setup.cfg",
                    "requirements.txt",
                    ".git",
                },
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    pylsp = {
                        plugins = {
                            pyflakes = { enabled = false },
                            pycodestyle = { enabled = false },
                            mccabe = { enabled = false },
                            rope_completion = { enabled = false },
                            rope_rename = { enabled = false },
                        },
                    },
                },
            })

            vim.lsp.config("rust_analyzer", {
                cmd = { "rust-analyzer" },
                root_markers = { "Cargo.toml", "rust-project.json", ".git" },
                capabilities = capabilities,
                on_attach = on_attach,
            })

            vim.lsp.config("texlab", {
                cmd = { "texlab" },
                root_markers = { ".latexmkrc", ".git", "main.tex" },
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    texlab = {
                        build = {
                            executable = "latexmk",
                            args = {
                                "-pdf",
                                "-interaction=nonstopmode",
                                "-synctex=1",
                                "-aux-directory=./build",
                                "-output-directory=./out",
                                "-bibtex",
                                "-lualatex",
                                "%f",
                            },
                            auxDirectory = "./build",
                            logDirectopury = "./build",
                            pdfDirectory = "./out",
                            onSave = true,
                        },
                        forwardSearch = {
                            executable = "latexmk",
                            args = {
                                "--synctex-forward",
                                "%l:1:%f",
                                "%p",
                            },
                        },
                    },
                },
            })

            vim.lsp.config("ltex", {
                cmd = { "ltex-ls" },
                on_attach = function(client, bufnr)
                    local bufopts = { noremap = true, silent = true, buffer = bufnr }
                    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
                    vim.notify("LSP attached: " .. client.name, vim.log.levels.INFO)
                    require("ltex_extra").setup({
                        load_langs = { "en-GB", "en-US" },
                        path = vim.fn.expand("~") .. "/.config/nvim/spell",
                    })
                end,
                capabilities = capabilities,
                filetypes = { "tex", "bib", "markdown", "text", "html" },
                flags = { debounce_text_changes = 300 },
                settings = {
                    ltex = {
                        enabled = { "latex", "tex", "bib", "markdown", "html" },
                        language = "en-GB",
                        diagnosticSeverity = "information",
                        sentenceCacheSize = 5000,
                        additionalRules = {
                            enablePickyRules = true,
                            motherTongue = "en",
                        },
                        disabledRules = {},
                    },
                },
            })

            vim.lsp.config("marksman", {
                cmd = { "marksman", "server" },
                filetypes = { "markdown" },
                rootmarkers = { ".marksman.toml" },
                capabilities = capabilities,
                on_attach = on_attach,
            })

            vim.lsp.config("hls", {
                cmd = { "haskell-language-server-wrapper", "--lsp" },
                root_markers = {
                    "hie.yaml",
                    "stack.yaml",
                    "cabal.project",
                    "package.yaml",
                    ".git",
                },
                capabilities = capabilities,
                on_attach = on_attach,
            })

            vim.lsp.config("r_language_server", {
                cmd = { "R", "--slave", "-e", "languageserver::run()" },
                root_markers = { ".Rprofile", "DESCRIPTION", ".git" },
                capabilities = capabilities,
                on_attach = on_attach,
            })

            vim.lsp.config("julials", {
                cmd = {
                    "julia",
                    "--startup-file=no",
                    "--history-file=no",
                    "-e",
                    [[
                                        using LanguageServer
                                        runserver()
                                ]],
                },
                root_markers = { "Project.toml", "JuliaProject.toml", ".git" },
                capabilities = capabilities,
                on_attach = on_attach,
                flags = {
                    exit_timeout = 5000,
                },
            })

            vim.lsp.config("clangd", {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--log=verbose",
                },
                init_options = {
                    clangdFileStatus = true,
                    clangdSemanticHighlighting = true,
                },
                filetypes = {
                    "c",
                    "cpp",
                    "objc",
                    "objcpp",
                    "cuda",
                },
                root_markers = {
                    ".clangd",
                    ".clang-tidy",
                    ".clang-format",
                    "compile_commands.json",
                    "compile_flags.txt",
                    "configure.ac", -- AutoTools
                    ".git",
                },
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ["clangd"] = {
                        ["compilationDatabasePath"] = "cmake",
                    },
                },
            })

            -- Setup Mason LSPConfig to ensure servers are installed
            -- Note: julials is NOT in ensure_installed because we configure it manually
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "ruff",
                    "pylsp",
                    "rust_analyzer",
                    "texlab",
                    "marksman",
                    -- "r_language_server",
                    "clangd",
                },
            })

            -- Enable all configured LSP servers
            vim.lsp.enable({
                "ruff",
                "pylsp",
                "rust_analyzer",
                "texlab",
                -- "ltex",
                "marksman",
                -- "r_language_server",
                -- "julials",
                "clangd",
            })
        end,
    },
}
