local M = {}

function M.setup(_, opts)
    vim.api.nvim_create_user_command(
        "BufferLineClose", 
        function(buffer_line_opts)
            local bufnr = 1 * buffer_line_opts.args
            local buf_is_modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })

            local bdelete_arg
            if bufnr == 0 then
                bdelete_arg = ""
            else
                bdelete_arg = " " .. bufnr
            end
            local command = "bdelete!" .. bdelete_arg
            if buf_is_modified then
                local option = vim.fn.confirm("File is not saved. Close anyway?", "&Yes\n&No", 2)
                if option == 1 then
                    vim.cmd(command)
                end
            else
                vim.cmd(command)
            end
        end,
        { nargs = 1 }
    )
    require("bufferline").setup(opts)

    require("nvim-web-devicons").setup {
        override = {
            typ = {
                icon = "󰰥",
                color = "#239dad",
                name = "typst",
            },
        },
    }
end

return M
