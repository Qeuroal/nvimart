return {
    -- library used by other plugins
    { "nvim-lua/plenary.nvim", lazy = true },

    -- tmux
    {
        "alexghergh/nvim-tmux-navigation",
        config = function()
            require("plugin.config.nvim_tmux_navigation").setup()
        end,
    },

    -- 高亮 RGB 颜色
    {
        "NvChad/nvim-colorizer.lua",
        main = "colorizer",
        event = "User Loading",
        opts = require("plugin.config.colorizer").opts(),
        config = function (_, opts)
            require("colorizer").setup(opts)
            vim.cmd "ColorizerToggle"
        end
    },

    {
        "numToStr/Comment.nvim",
        main = "Comment",
        opts = {
            mappings = { basic = true, extra = true, extended = false },
        },
        config = function(_, opts)
            require("plugin.config.comment").setup(_, opts)
        end,
        keys = function()
            return require("plugin.config.comment").keymapping()
        end,
    },
}
