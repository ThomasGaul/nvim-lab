-- File: lua/config/splash.lua
local function center_text(lines)
    local width = vim.api.nvim_get_option("columns")
    return vim.tbl_map(function(line)
        local padding = math.floor((width - #line) / 2)
        return string.rep(" ", math.max(padding, 0)) .. line
    end, lines)
end

local function show_splash()
    if vim.fn.argc() > 0 then return end -- Don't show if files are passed

    vim.api.nvim_command("enew")  -- New empty buffer
    vim.bo.buflisted = false
    vim.bo.buftype = "nofile"
    vim.bo.swapfile = false
    vim.bo.bufhidden = "wipe"
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.cursorline = false

    local splash = {
        "",
        "N V I M - L A B",
        "",
        "[n] New file           [b] Browse files",
        "[g] Grep text          [r] Recent files",
        "[q] Quit Nvim          [z] Open REPL   ",
        "",
        "",
        "...we are driven about in many ways by external causes, and that, like waves on the sea, driven by contrary winds, we toss about, not knowing our outcome or fate.",
        "",
        "~ Baruch D. Spinoza",
        "",
        "",
        "It is easy to imagine a language consisting only of order and reports in battle. –",
        "Or a language consisting only of questions and expressions for answering Yes or No –",
        "and countless other things. –",
        "And to imagine a language means to imagine a form of life.",
        "",
        "~ Ludwig Wittgenstein"
    }

    local lines = center_text(splash)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

    vim.wo.foldenable = false

    -- Optional: key mappings for quick access
    vim.keymap.set("n", "f", "<cmd>Telescope find_files<CR>", { buffer = 0, silent = true })
    vim.keymap.set("n", "g", "<cmd>Telescope live_grep<CR>", { buffer = 0, silent = true })
    vim.keymap.set("n", "r", "<cmd>Telescope oldfiles<CR>", { buffer = 0, silent = true })
    vim.keymap.set("n", "b", "<cmd>Telescope file_browser hidden=true<CR>", { buffer = 0, silent = true })
    vim.keymap.set("n", "q", "<cmd>qa<CR>", { buffer = 0, silent = true })
    vim.keymap.set("n", "n", function()
        local filename = vim.fn.input("New file: ", "", "file")
        if filename ~= "" then
            vim.cmd("edit " .. filename)
        end
    end, { buffer = 0, silent = true, desc = "Create and open new file" })
    vim.keymap.set("n", "z", function()
        local languages = { "python", "julia", "haskell", "r" }
        vim.ui.select(languages, {
            prompt = "Select REPL Language",
            format_item = function(item)
                return " " .. item -- minimal symbol instead of icon
            end,
        }, function(choice)
            if choice then
                vim.cmd("IronFocus " .. choice)
            end
        end)
    end, { buffer = 0, silent = true, desc = "Launch REPL in current window" })
end

return { show = show_splash }
