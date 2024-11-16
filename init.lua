require("bootstrap"):init()

require("config")
require("plugin")
require("lsp")

baseUtils = require("utils.basic")

-- Load user configuration files
local config_root = string.gsub(vim.fn.stdpath "config", "\\", "/")
if not vim.api.nvim_get_runtime_file("lua/custom/", false)[1] then
    os.execute('mkdir "' .. config_root .. '/lua/custom"')
end

local custom_path = config_root .. "/lua/custom/"
if baseUtils.file_exists(custom_path .. "init.lua") then
    require "custom.init"
end

-- Define keymap
local keymap = gvimconf.keymap.general
baseUtils.group_map(keymap)

for filetype, config in pairs(gvimconf.ft) do
    baseUtils.ft(filetype, config)
end

-- Only load plugins and colorscheme when --noplugin arg is not present
if not baseUtils.noplugin then
    -- Load plugins
    local config = {}
    for _, plugin in pairs(gvimconf.plugin) do
        config[#config + 1] = plugin
    end
    require("lazy").setup(config, gvimconf.lazy)

    baseUtils.group_map(gvimconf.keymap.plugins)

    -- Define colorscheme
    if not gvimconf.colorscheme then
        local colorscheme_cache = vim.fn.stdpath "data" .. "/colorscheme"
        if baseUtils.file_exists(colorscheme_cache) then
            local colorscheme_cache_file = io.open(colorscheme_cache, "r")
            ---@diagnostic disable: need-check-nil
            local colorscheme = colorscheme_cache_file:read "*a"
            colorscheme_cache_file:close()
            gvimconf.colorscheme = colorscheme
        else
            gvimconf.colorscheme = "onedark"
        end
    end

    require("plugin.utils").colorscheme(gvimconf.colorscheme)
end

-- Prepend this to runtimepath last as it would be overridden by lazy otherwise
if vim.uv.fs_scandir(custom_path) then
    vim.opt.rtp:prepend(custom_path)
end


