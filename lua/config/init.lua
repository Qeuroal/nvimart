-- global
gvimconf.symbols = require("config.symbol")
gvimconf.ft = require("config.filetype")

local settings = require("config.settings")
settings.loadDefaultConfig()
require("config.keymappings")







































-- vim.g.mapleader = (gvimconf.leader == "space" and " ") or gvimconf.leader


-- -- Searching
-- vim.opt.incsearch = true -- search as characters are entered
-- vim.opt.hlsearch = false -- do not highlight matches
-- vim.opt.ignorecase = true -- ignore case in searches by default
-- vim.opt.smartcase = true -- but make it case sensitive if an uppercase is entered

-- -- For nvim-tree
-- -- disable netrw at the very start of your init.lua (strongly advised)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
