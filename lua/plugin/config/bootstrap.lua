local M = {}

local corePlugin = {
}

function M.config(config)
    for _, path in ipairs(corePlugin) do
        local item = reload(path)
        item.config(config)
    end
end

return M
