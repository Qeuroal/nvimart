require("plugin.core")
-- require("plugin.lsp")

local pluginList = gvimconf.plugin.list
pluginList.autoload = { import = "plugin.autoload" }
pluginList.lsp_init = require("plugin.lsp.init")


