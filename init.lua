require("bootstrap"):init()

require("config")
require("plugin")

local baseUtils = require("utils.basic")

-- Load user configuration files
local config_root = string.gsub(vim.fn.stdpath "config", "\\", "/")
if not vim.api.nvim_get_runtime_file("lua/custom/", false)[1] then
    os.execute('mkdir "' .. config_root .. '/lua/custom"')
end

local custom_path = config_root .. "/lua/custom/"
if baseUtils.file_exists(custom_path .. "init.lua") then
    require("custom.init")
end

-- Define keymap
local keymap = gvimconf.keymap.general
baseUtils.group_map(keymap)

for filetype, config in pairs(gvimconf.ft) do
    baseUtils.ft(filetype, config)
end

-- Prepend this to runtimepath last as it would be overridden by lazy otherwise
if vim.uv.fs_scandir(custom_path) then
    vim.opt.rtp:prepend(custom_path)
end


