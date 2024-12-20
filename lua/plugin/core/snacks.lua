-- Terminal Mappings
local function term_nav(dir)
    ---@param self snacks.terminal
    return function(self)
        return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
            vim.cmd.wincmd(dir)
        end)
    end
end

gvimconf.plugin.list.snacks = {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function()
        ---@type snacks.Config
        return {
            notifier = { enabled = true },
            quickfile = { enabled = true },
            bigfile = { enabled = true },
            words = { enabled = true },
            toggle = { map = gvimconf.utils.safe_keymap_set },
            statuscolumn = { enabled = false }, -- we set this in options.lua
            terminal = {
                win = {
                    keys = {
                        nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
                        nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
                        nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
                        nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
                    },
                },
            },
        }
    end,
    keys = {
        {
            "<leader>un",
            function()
                Snacks.notifier.hide()
            end,
            desc = "Dismiss All Notifications",
        },
    },
}
