return {
    {
        "mhartington/formatter.nvim",
        config = function()
            local util = require("formatter.util")
            require("formatter").setup({
                filetype = {
                    lua = {
                        require("formatter.filetypes.lua").stylua,
                    },
                    python = {
                        require("formatter.filetypes.python").ruff,
                    },
                    c = {
                        require("formatter.filetypes.c").clangformat,
                    },
                    cpp = {
                        require("formatter.filetypes.cpp").clangformat,
                    },
                    cmake = {
                        require("formatter.filetypes.cmake").cmakeformat,
                    },
                    rust = {
                        require("formatter.filetypes.rust").rustfmt,
                    },
                    html = {
                        require("formatter.filetypes.html").tidy,
                    },
                    tex = {
                        require("formatter.filetypes.latex").latexindent,

                        function()
                            return {
                                exe = "latexindent -",
                                args = {
                                    "-l",
                                },
                                stdin = true,
                            }
                        end,
                    },
                    markdown = {
                        require("formatter.filetypes.markdown").mdformat,
                    },
                    sh = {
                        require("formatter.filetypes.sh").shfmt,
                    },
                    bib = {
                        function()
                            return {
                                exe = "bibtex-tidy",
                                args = {
                                    -- "--modify",
                                    "--curly",
                                    "--months",
                                    "--space=4",
                                    "--align=14",
                                    "--blank-lines",
                                    "--sort=author,year,title",
                                    "--duplicates",
                                    "--drop-all-caps",
                                    "--escape",
                                    "--sort-fields=author,editor,translator,title,subtitle,maintitle,series,journal,publisher,organization,year,origdate,month,date,volume,number,pages,chapter,edition,school,institution,address,type,howpublished,language,doi,url,urldate",
                                    "--strip-comments",
                                    "--no-trailing-commas",
                                    "--encode-urls",
                                    "--remove-empty-fields",
                                    "--remove-dupe-fields",
                                    "--wrap=90",
                                    util.escape_path(util.get_current_buffer_file_path()),
                                },
                                stdin = true,
                                try_node_modules = true,
                            }
                        end,
                    },
                },
            })
        end,
    },
}
