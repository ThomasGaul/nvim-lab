return {
    {
        "goerz/jupytext.nvim",
        opts = {},
    },
    -- image.nvim
    {
        "3rd/image.nvim",
        opts = {
            backend = "kitty",
            integrations = {
                markdown = {
                    enabled = true,
                    clear_in_insert_mode = true,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                },
                html = {
                    enabled = false,
                },
                css = {
                    enabled = false,
                },
            },
            -- Inline rendering settings
            max_width = 500,
            max_height = 500,
            max_width_window_percentage = math.huge,
            max_height_window_percentage = math.huge,

            -- Keep images inline with text
            window_overlap_clear_enabled = true,
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },

            -- Inline behavior
            editor_only_render_when_focused = false,
            tmux_show_only_in_active_window = true,

            -- Hijack file protocol for inline display
            hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
        },
    },
    -- Molten
    {
        "benlubas/molten-nvim",
        version = "^1.0.0",
        dependencies = { "3rd/image.nvim" },
        build = ":UpdateRemotePlugins",
        init = function()
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 60 -- Give more room for images
            vim.g.molten_auto_image_popup = false
            vim.g.molten_auto_open_output = true
            vim.g.molten_wrap_output = false
            vim.g.molten_virt_text_output = true
            vim.g.molten_image_location = "float"
            vim.g.molten_auto_open_html_in_browser = false
            vim.g.molten_open_cmd = "/usr/local/bin/kitty-elinks.sh"
        end,
        config = function()
            -- Function to evaluate code between # %% markers
            local function evaluate_cell()
                local cursor_pos = vim.api.nvim_win_get_cursor(0)
                local current_line = cursor_pos[1]

                -- Search backward for cell delimiter
                local start_line = current_line
                for i = current_line, 1, -1 do
                    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
                    if line:match("^#%s*%%%%") then
                        start_line = i + 1
                        break
                    end
                    if i == 1 then
                        start_line = 1
                    end
                end

                -- search forward for last non-empty line before next cell delimiter
                local end_line = current_line
                local total_lines = vim.api.nvim_buf_line_count(0)
                for i = current_line, total_lines do
                    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
                    if line:match(".") ~= nil and line:match("^#%s*%%%%") == nil then
                        end_line = i
                    end
                    if line:match("^#%s*%%%%") then
                        break
                    end
                end

                -- Set visual selection marks
                vim.api.nvim_buf_set_mark(0, "<", start_line, 0, {})
                vim.api.nvim_buf_set_mark(0, ">", end_line, 1000, {})

                -- Evaluate the cell
                vim.cmd("MoltenEvaluateVisual")
            end

            -- Create the command
            vim.api.nvim_create_user_command("MoltenEvaluateCell", evaluate_cell, {})

            -- Keybindings
            vim.keymap.set(
                "n",
                "<localleader>mc",
                ":MoltenEvaluateCell<CR>",
                { silent = true, desc = "Evaluate cell" }
            )
            vim.keymap.set(
                "n",
                "<localleader>mi",
                ":MoltenInit<CR>",
                { silent = true, desc = "Initialize Molten" }
            )
            vim.keymap.set(
                "n",
                "<localleader>ml",
                ":MoltenEvaluateLine<CR>",
                { silent = true, desc = "Evaluate line" }
            )
            vim.keymap.set(
                "v",
                "<localleader>mv",
                ":<C-u>MoltenEvaluateVisual<CR>gv",
                { silent = true, desc = "Evaluate visual" }
            )
            vim.keymap.set(
                "n",
                "<localleader>mo",
                ":noautocmd MoltenEnterOutput<CR>",
                { silent = true, desc = "Enter output window" }
            )
            vim.keymap.set(
                "n",
                "<localleader>mb",
                ":MoltenOpenInBrowser<CR>",
                { silent = true, desc = "Open output in browser using molten_open_cmd" }
            )
        end,
    },
}
