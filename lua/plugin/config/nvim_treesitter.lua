local M = {}

function M.opts()
    return {
        ensure_installed = {
            "bash",
            "c",
            "c_sharp",
            "cpp",
            "css",
            "go",
            "html",
            "javascript",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "rust",
            "typescript",
            "typst",
            "tsx",
            "vim",
            "vimdoc",
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            disable = function(_, buf)
                local max_filesize = 100 * 1024
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>",
                node_incremental = "<CR>",
                node_decremental = "<BS>",
                scope_incremental = "<TAB>",
            },
        },
        indent = {
            enable = true,
            -- conflicts with flutter-tools.nvim, causing performance issues
            disable = { "dart" },
        },
    }
end

function M.setup(_, opts)
    require("nvim-treesitter.install").prefer_git = true
    require("nvim-treesitter.configs").setup(opts)

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false

    local rainbow_delimiters = require "rainbow-delimiters"

    vim.g.rainbow_delimiters = {
        strategy = {
            [""] = rainbow_delimiters.strategy["global"],
            vim = rainbow_delimiters.strategy["local"],
        },
        query = {
            [""] = "rainbow-delimiters",
            lua = "rainbow-blocks",
        },
        highlight = {
            "RainbowDelimiterRed",
            "RainbowDelimiterYellow",
            "RainbowDelimiterBlue",
            "RainbowDelimiterOrange",
            "RainbowDelimiterGreen",
            "RainbowDelimiterViolet",
            "RainbowDelimiterCyan",
        },
    }
end

return M
