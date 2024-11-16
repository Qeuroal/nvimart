local M = {}

function M:init()
    -- must first line
    _G.gvimconf = vim.deepcopy(require("default"))

    -- plugin config bootstrap
    local plugins = require("plugin.config.bootstrap")
    plugins.config({})
end

return M
