local M = {}

function M:init()
    -- must first line
    gvimconf = vim.deepcopy(require("default"))

    local plugins = require("plugin.config.bootstrap")
    plugins.config({})
end

return M
