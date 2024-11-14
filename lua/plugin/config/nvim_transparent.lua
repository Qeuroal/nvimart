local M = {}

function M.setup(_, opts)
    local autogroup = vim.api.nvim_create_augroup("transparent", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = autogroup,
        callback = function()
            local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
            local foreground = string.format("#%06x", normal_hl.fg)
            local background = string.format("#%06x", normal_hl.bg)
            vim.api.nvim_command("highlight default NvimartNormal guifg=" .. foreground .. " guibg=" .. background)

            require("transparent").clear()
        end,
    })
    -- Enable transparent by default
    local transparent_cache = vim.fn.stdpath "data" .. "/transparent_cache"
    if not require("utils.basic").file_exists(transparent_cache) then
        local f = io.open(transparent_cache, "w")
        f:write "true"
        f:close()
    end

    require("transparent").setup(opts)

    local old_get_hl = vim.api.nvim_get_hl
    vim.api.nvim_get_hl = function(ns_id, opt)
        if opt.name == "Normal" then
            local attempt = old_get_hl(0, { name = "NvimartNormal" })
            if next(attempt) ~= nil then
                opt.name = "NvimartNormal"
            end
        end
        return old_get_hl(ns_id, opt)
    end
end

return M
