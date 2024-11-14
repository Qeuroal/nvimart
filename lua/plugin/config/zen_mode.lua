local M = {}

function M.opts()
    return {
        window = {
            backdrop = 0.8,
            width = vim.fn.winwidth(0) - 16,
            height = vim.fn.winheight(0) + 1,
        },
        on_open = function()
            vim.opt.cmdheight = 1
        end,
        on_close = function()
            vim.opt.cmdheight = 2
        end,
    }
end

function M.setup(_, opts)
    vim.api.nvim_command "highlight link ZenBg NvimartNormal"
    require("zen-mode").setup(opts)
end

return M


