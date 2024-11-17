
-- Add Loading event
-- If user starts neovim but does not edit a file, i.e., entering Dashboard directly, the Loading event is hooked to the next BufRead event. 
-- Otherwise, the event is triggered right after the VeryLazy event.
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        local function _trigger()
            vim.api.nvim_exec_autocmds("User", { pattern = "Loading" })
        end

        if vim.bo.filetype == "dashboard" then
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "*/*",
                once = true,
                callback = _trigger,
            })
        else
            _trigger()
        end
    end,
})

