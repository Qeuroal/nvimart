-- local plugin = require("plugin.plugins")
-- plugin.load()

require("plugin.plugins")
require("plugin.colorscheme")
require("plugin.keymappings")

-- Only load plugins and colorscheme when --noplugin arg is not present
local baseUtils = require("utils.basic")
if not baseUtils.noplugin then
    -- Load plugins
    local config = {}
    for _, plugin in pairs(gvimconf.plugin.list) do
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

