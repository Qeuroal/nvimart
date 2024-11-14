local M = {}

function M.config()
    return {
        -- https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=NVIMART%0A
        header = {
            " ",
            "███╗   ██╗██╗   ██╗██╗███╗   ███╗ █████╗ ██████╗ ████████╗",
            "████╗  ██║██║   ██║██║████╗ ████║██╔══██╗██╔══██╗╚══██╔══╝",
            "██╔██╗ ██║██║   ██║██║██╔████╔██║███████║██████╔╝   ██║   ",
            "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██║██╔══██╗   ██║   ",
            "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║██║  ██║   ██║   ",
            "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ",
            " ",
            string.format("                      %s                       ", require("utils.basic").version),
            " ",
        },
        center = {
            {
                icon = "  ",
                desc = "Lazy Profile",
                action = "Lazy profile",
            },
            {
                icon = "  ",
                desc = "Edit preferences   ",
                action = string.format("edit %s/lua/custom/init.lua", config_root),
            },
            {
                icon = "  ",
                desc = "Mason",
                action = "Mason",
            },
            {
                icon = "  ",
                desc = "About nvimart",
                action = "lua require('plugin.utils').about()",
            },
        },
        footer = { "🧊 Hope that you enjoy using nvimart." },
    }
end

return M
