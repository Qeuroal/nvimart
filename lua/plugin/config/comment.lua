local M = {}

function M.keymapping()
    local vvar = vim.api.nvim_get_vvar

    local toggle_current_line = function()
        if vvar "count" == 0 then
            return "<Plug>(comment_toggle_linewise_current)"
        else
            return "<Plug>(comment_toggle_linewise_count)"
        end
    end

    local toggle_current_block = function()
        if vvar "count" == 0 then
            return "<Plug>(comment_toggle_blockwise_current)"
        else
            return "<Plug>(comment_toggle_blockwise_count)"
        end
    end

    local comment_below = function()
        require("Comment.api").insert.linewise.below()
    end

    local comment_above = function()
        require("Comment.api").insert.linewise.above()
    end

    local comment_eol = function()
        require("Comment.api").locked "insert.linewise.eol"()
    end

    return {
        { "<leader>c", "<Plug>(comment_toggle_linewise)", desc = "comment toggle linewise" },
        { "<leader>ca", "<Plug>(comment_toggle_blockwise)", desc = "comment toggle blockwise" },
        { "<leader>cc", toggle_current_line, expr = true, desc = "comment toggle current line" },
        { "<leader>cb", toggle_current_block, expr = true, desc = "comment toggle current block" },
        { "<leader>cc", "<Plug>(comment_toggle_linewise_visual)", mode = "x", desc = "comment toggle linewise" },
        { "<leader>cb", "<Plug>(comment_toggle_blockwise_visual)", mode = "x", desc = "comment toggle blockwise" },
        { "<leader>co", comment_below, desc = "comment insert below" },
        { "<leader>cO", comment_above, desc = "comment insert above" },
        { "<leader>cA", comment_eol, desc = "comment insert end of line" },
    }
end

function M.setup(_, opts)
    require("Comment").setup(opts)

    -- Remove the keymap defined by Comment.nvim
    vim.keymap.del("n", "gcc")
    vim.keymap.del("n", "gbc")
    vim.keymap.del("n", "gc")
    vim.keymap.del("n", "gb")
    vim.keymap.del("x", "gc")
    vim.keymap.del("x", "gb")
    vim.keymap.del("n", "gcO")
    vim.keymap.del("n", "gco")
    vim.keymap.del("n", "gcA")
end

return M
