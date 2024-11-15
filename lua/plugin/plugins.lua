-- Configuration for each individual plugin
---@diagnostic disable: need-check-nil
local config = {}
local symbols = gvimconf.symbols
local config_root = string.gsub(vim.fn.stdpath "config", "\\", "/")
local priority = {
    LOW = 100,
    MEDIUM = 200,
    HIGH = 615,
}

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

config.bufferline = {
    "akinsho/bufferline.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    event = "User Loading",
    opts = {
        options = {
            close_command = ":BufferLineClose %d",
            right_mouse_command = ":BufferLineClose %d",
            separator_style = "thin",
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "left",
                },
            },
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(_, _, diagnostics_dict, _)
                local s = " "
                for e, n in pairs(diagnostics_dict) do
                    local sym = e == "error" and symbols.Error or (e == "warning" and symbols.Warn or symbols.Info)
                    s = s .. n .. sym
                end
                return s
            end,
        },
    },
    config = function(_, opts)
        require("plugin.config.bufferline").setup(_, opts)
    end,
    keys = require("plugin.config.bufferline").keymap(),
}

-- 高亮 RGB 颜色
config.colorizer = {
    "NvChad/nvim-colorizer.lua",
    main = "colorizer",
    event = "User Loading",
    opts = {
        filetypes = {
            "*",
            css = {
                names = true,
            },
        },
        user_default_options = {
            css = true,
            css_fn = true,
            names = false,
            always_update = true,
        },
    },
    config = function (_, opts)
        require("colorizer").setup(opts)
        vim.cmd "ColorizerToggle"
    end
}

config.comment = {
    "numToStr/Comment.nvim",
    main = "Comment",
    opts = {
        mappings = { basic = true, extra = true, extended = false },
    },
    config = function(_, opts)
        require("plugin.config.comment").setup(_, opts)
    end,
    keys = function()
        return require("plugin.config.comment").setKeymapping()
    end,
}

config.dashboard = {
    "nvimdev/dashboard-nvim",
    lazy = false,
    opts = {
        theme = "doom",
        config = require("plugin.config.dashboard_nvim").config(),
    },
    config = function(_, opts)
        require("dashboard").setup(opts)
    end,
}

config.gitsigns = {
    "lewis6991/gitsigns.nvim",
    event = "User Loading",
    main = "gitsigns",
    opts = {},
    keys = require("plugin.config.gitsigns").setKeymapping(),
}

-- config["grug-far"] = {
--     "MagicDuck/grug-far.nvim",
--     opts = {
--         disableBufferLineNumbers = true,
--         startInInsertMode = true,
--         windowCreationCommand = "tabnew %",
--     },
--     keys = {
--         { "<leader>ug", "<Cmd>GrugFar<CR>", desc = "find and replace", silent = true, noremap = true },
--     },
-- }

config.hop = {
    "smoka7/hop.nvim",
    main = "hop",
    opts = {
        -- This is actually equal to:
        --   require("hop.hint").HintPosition.END
        hint_position = 3,
        keys = "fjghdksltyrueiwoqpvbcnxmza",
    },
    keys = {
        { "<leader>hp", "<Cmd>HopWord<CR>", desc = "hop word", silent = true, noremap = true },
    },
}

config["indent-blankline"] = {
    "lukas-reineke/indent-blankline.nvim",
    event = "User Loading",
    main = "ibl",
    opts = require("plugin.config.indent_blankline").opts(),
}

config.lualine = {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "arkav/lualine-lsp-progress",
    },
    event = "User Loading",
    main = "lualine",
    opts = require("plugin.config.lualine").opts(),
}

-- config["markdown-preview"] = {
--     "iamcco/markdown-preview.nvim",
--     ft = "markdown",
--     config = function()
--         vim.g.mkdp_filetypes = { "markdown" }
--         vim.g.mkdp_auto_close = 0
--     end,
--     build = "cd app && yarn install",
--     keys = {
--         {
--             "<A-b>",
--             "<Cmd>MarkdownPreviewToggle<CR>",
--             desc = "markdown preview",
--             ft = "markdown",
--             silent = true,
--             noremap = true,
--         },
--     },
-- }

config.neogit = {
    "NeogitOrg/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    main = "neogit",
    opts = {
        disable_hint = true,
        status = {
            recent_commit_count = 30,
        },
        commit_editor = {
            kind = "auto",
            show_staged_diff = false,
        },
    },
    keys = {
        { "<leader>gt", "<Cmd>Neogit<CR>", desc = "neogit", silent = true, noremap = true },
    },
    config = function(_, opts)
        require("neogit").setup(opts)
        gvimconf.ft.NeogitCommitMessage = function()
            vim.api.nvim_win_set_cursor(0, { 1, 0 })
        end
    end,
}

-- config.neoscroll = {
--     "karb94/neoscroll.nvim",
--     main = "neoscroll",
--     opts = {
--         mappings = {},
--         hide_cursor = true,
--         stop_eof = true,
--         respect_scrolloff = false,
--         cursor_scrolls_alone = true,
--         easing_function = "sine",
--         pre_hook = nil,
--         post_hook = nil,
--         performance_mode = false,
--     },
--     keys = {
--         {
--             "<C-u>",
--             function()
--                 require("neoscroll").scroll(-vim.wo.scroll, true, 250)
--             end,
--             desc = "scroll up",
--         },
--         {
--             "<C-d>",
--             function()
--                 require("neoscroll").scroll(vim.wo.scroll, true, 250)
--             end,
--             desc = "scroll down",
--         },
--     },
-- }

-- config["nvim-scrollview"] = {
--     "dstein64/nvim-scrollview",
--     event = "User Loading",
--     main = "scrollview",
--     opts = {
--         excluded_filetypes = { "nvimtree" },
--         current_only = true,
--         winblend = 75,
--         base = "right",
--         column = 1,
--     },
-- }

config.nui = {
    "MunifTanjim/nui.nvim",
    lazy = true,
}

config["nvim-autopairs"] = {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    main = "nvim-autopairs",
    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
    opts = {},
}

config["nvim-notify"] = {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
        timeout = 3000,
        background_colour = "#000000",
        stages = "static",
    },
    config = function(_, opts)
        ---@diagnostic disable-next-line: undefined-field
        require("notify").setup(opts)
        vim.notify = require "notify"
    end,
}

config["nvim-transparent"] = {
    "xiyaowong/nvim-transparent",
    opts = {
        extra_groups = {
            "NvimTreeNormal",
            "NvimTreeNormalNC",
        },
    },
    config = function(_, opts)
        require("plugin.config.nvim_transparent").setup(_, opts)
    end,
}

config["nvim-tree"] = {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = require("plugin.config.nvim_tree").opts(),
    keys = {
        { "<leader>e", "<Cmd>NvimTreeToggle<CR>", desc = "toggle nvim tree", silent = true, noremap = true },
    },
}

config["nvim-treesitter"] = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "hiphish/rainbow-delimiters.nvim" },
    -- Do not lazy load if file does not exist
    --
    -- Why this is needed:
    --
    -- Because nvim-treesitter needs to be loaded early, which is why using "VeryLazy" would not load it in time if we
    -- open a file directly upon startup. BufRead, on the other hand, loads nvim-treesitter in time for a file but does
    -- not load it in dashboard, hence doing well with startup time.
    --
    -- However, BufRead is not fired for non-existent files. So, if we use `nvim <new-file>`, nvim-treesitter would not
    -- be loaded for that new file. In this case, the only solution I could see is to prevent lazy loading of the plugin
    -- altogether.
    lazy = (function()
        local file_name = vim.fn.expand "%:p"
        return file_name == "" or require("utils.basic").file_exists(file_name)
    end)(),
    event = "BufRead",
    main = "nvim-treesitter",
    opts = require("plugin.config.nvim_treesitter").opts(),
    config = function(_, opts)
        require("plugin.config.nvim_treesitter").setup(_, opts)
    end,
}

-- config["rust-tools"] = {
--     "simrat39/rust-tools.nvim",
--     dependencies = { "nvim-lua/plenary.nvim" },
--     ft = "rust",
--     main = "rust-tools",
--     opts = {
--         server = {
--             on_attach = function(_, bufnr)
--                 gvimconf.lsp.keyAttach(bufnr)
--             end,
--         },
--     },
-- }

config.surround = {
    "kylechui/nvim-surround",
    version = "*",
    opts = {},
    event = "User Loading",
}

config.telescope = {
    "nvim-telescope/telescope.nvim",
    dependencies = require("plugin.config.telescope").dependencies(),
    -- ensure that other plugins that use telescope can function properly
    cmd = "Telescope",
    opts = require("plugin.config.telescope").opts(),
    config = function(_, opts)
        require("plugin.config.telescope").opts()
    end,
    keys = require("plugin.config.telescope").keymapping(),
}

-- config["todo-comments"] = {
--     "folke/todo-comments.nvim",
--     dependencies = {
--         "nvim-lua/plenary.nvim",
--     },
--     event = "User Loading",
--     main = "todo-comments",
--     opts = {},
--     keys = {
--         { "<leader>ut", "<Cmd>TodoTelescope<CR>", desc = "todo list", silent = true, noremap = true },
--     },
-- }

config.undotree = {
    "mbbill/undotree",
    config = function()
        vim.g.undotree_WindowLayout = 2
        vim.g.undotree_TreeNodeShape = "-"
    end,
    keys = {
        { "<leader>uu", "<Cmd>UndotreeToggle<CR>", desc = "undo tree toggle", silent = true, noremap = true },
    },
}

config["which-key"] = {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = require("plugin.config.which_key").opts(),
}

config["zen-mode"] = {
    "folke/zen-mode.nvim",
    -- Set high priority to ensure this is loaded before nvim-transparent
    priority = priority.HIGH,
    opts = require("plugin.config.zen_mode").opts(),
    config = function(_, opts)
        require("plugin.config.zen_mode").setup(_, opts)
    end,
    keys = {
        { "<leader>uz", "<Cmd>ZenMode<CR>", desc = "toggle zen mode", silent = true, noremap = true },
    },
}

-- tmux
config["nvim-tmux-navigation"] = {
    "alexghergh/nvim-tmux-navigation",
    config = function()
        require("plugin.config.nvim_tmux_navigation").setup()
    end,
}

-- Colorschemes
config["ayu"] = {
    "Luxed/ayu-vim",
    lazy = true,
}

config["github"] = {
    "projekt0n/github-nvim-theme",
    lazy = true,
}

config["gruvbox"] = {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
}

config["kanagawa"] = {
    "rebelot/kanagawa.nvim",
    lazy = true,
}

config["nightfox"] = {
    "EdenEast/nightfox.nvim",
    lazy = true,
}

config["tokyonight"] = {
    "folke/tokyonight.nvim",
    lazy = true,
}

config["onedark"] = {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
}

gvimconf.plugins = config
gvimconf.keymap.prefix = {
    { "<leader>b", group = "+buffer" },
    { "<leader>c", group = "+comment" },
    { "<leader>g", group = "+git" },
    { "<leader>h", group = "+hop" },
    { "<leader>l", group = "+lsp" },
    { "<leader>t", group = "+telescope" },
    { "<leader>u", group = "+utils" },
}











































-- require("plugin.config.lazy")

-- local M = {}
-- local plugins = {
--     -- color
--     {
--         "olimorris/onedarkpro.nvim",
--         priority = 1000, -- Ensure it loads first
--     },

-- }

-- M.loadPlugins = function()
--     require("lazy").setup(plugins)
--     require("onedarkpro").load()
-- end

-- M.load = function() 
--     M.loadPlugins()
-- end

-- return M
