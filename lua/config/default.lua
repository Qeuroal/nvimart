---@class gvimconf.Config: VimOptions
local M = {}

M.version = "1.0" -- x-release-please-version
local defaults = {
    -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
    ---@type string|fun()
    colorscheme = function()
        require("onedark").load()
    end,
    -- load the default settings
    defaults = {
        autocmds = true, -- gvimconf.config.autocmds
        keymaps = true, -- gvimconf.config.keymaps
        -- gvimconf.config.options can't be configured here since that's loaded before gvimconf setup
        -- if you want to disable loading options, add `package.loaded["gvimconf.config.options"] = true` to the top of your init.lua
    },
    news = {
        -- When enabled, NEWS.md will be shown when changed.
        -- This only contains big new features and breaking changes.
        vimart = true,
        -- Same but for Neovim's news.txt
        neovim = false,
    },
    -- icons used by other plugins
    -- stylua: ignore
    icons = require("assets.icons"),
    ---@type table<string, string[]|boolean>?
    kind_filter = {
        default = {
            "Class",
            "Constructor",
            "Enum",
            "Field",
            "Function",
            "Interface",
            "Method",
            "Module",
            "Namespace",
            "Package",
            "Property",
            "Struct",
            "Trait",
        },
        markdown = false,
        help = false,
        -- you can specify a different filter for each filetype
        lua = {
            "Class",
            "Constructor",
            "Enum",
            "Field",
            "Function",
            "Interface",
            "Method",
            "Module",
            "Namespace",
            -- "Package", -- remove package since luals uses it for control flow structures
            "Property",
            "Struct",
            "Trait",
        },
    },
}

M.json = {
    version = 7,
    path = vim.g.gvimconf_json or vim.fn.stdpath("config") .. "/gvimconf.json",
    data = {
        version = nil, ---@type string?
        news = {}, ---@type table<string, string>
        extras = {}, ---@type string[]
    },
}

function M.json.load()
    local f = io.open(M.json.path, "r")
    if f then
        local data = f:read("*a")
        f:close()
        local ok, json = pcall(vim.json.decode, data, { luanil = { object = true, array = true } })
        if ok then
            M.json.data = vim.tbl_deep_extend("force", M.json.data, json or {})
            if M.json.data.version ~= M.json.version then
                gvimconf.utils.json.migrate()
            end
        end
    end
end

---@type VimOptions
local options
local lazy_clipboard

---@param opts? VimOptions
function M.setup(opts)
    options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}

    -- autocmds can be loaded lazily when not opening a file
    local lazy_autocmds = vim.fn.argc(-1) == 0
    if not lazy_autocmds then
        M.load("autocmds")
    end

    local group = vim.api.nvim_create_augroup("gvimconf", { clear = true })
    vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "VeryLazy",
        callback = function()
            if lazy_autocmds then
                M.load("autocmds")
            end
            M.load("keymaps")
            if lazy_clipboard ~= nil then
                vim.opt.clipboard = lazy_clipboard
            end

            gvimconf.utils.format.setup()
            gvimconf.utils.news.setup()
            gvimconf.utils.root.setup()

            vim.api.nvim_create_user_command("LazyExtras", function()
                gvimconf.utils.extras.show()
            end, { desc = "Manage gvimconf.utils extras" })

            vim.api.nvim_create_user_command("LazyHealth", function()
                vim.cmd([[Lazy! load all]])
                vim.cmd([[checkhealth]])
            end, { desc = "Load all plugins and run :checkhealth" })

            local health = require("lazy.health")
            vim.list_extend(health.valid, {
                "recommended",
                "desc",
                "vscode",
            })
        end,
    })

    gvimconf.utils.track("colorscheme")
    gvimconf.utils.try(function()
        if type(M.colorscheme) == "function" then
            M.colorscheme()
        else
            vim.cmd.colorscheme(M.colorscheme)
        end
    end, {
            msg = "Could not load your colorscheme",
            on_error = function(msg)
                gvimconf.utils.error(msg)
                vim.cmd.colorscheme("habamax")
            end,
        })
    gvimconf.utils.track()
end

---@param buf? number
---@return string[]?
function M.get_kind_filter(buf)
    buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
    local ft = vim.bo[buf].filetype
    if M.kind_filter == false then
        return
    end
    if M.kind_filter[ft] == false then
        return
    end
    if type(M.kind_filter[ft]) == "table" then
        return M.kind_filter[ft]
    end
    ---@diagnostic disable-next-line: return-type-mismatch
    return type(M.kind_filter) == "table" and type(M.kind_filter.default) == "table" and M.kind_filter.default or nil
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
    local function _load(mod)
        if require("lazy.core.cache").find(mod)[1] then
            gvimconf.utils.try(function()
                require(mod)
            end, { msg = "Failed loading " .. mod })
        end
    end
    local pattern = "gvimconf.utils" .. name:sub(1, 1):upper() .. name:sub(2)
    -- always load gvimconf, then user file
    if M.defaults[name] or name == "options" then
        _load("gvimconf.config." .. name)
        vim.api.nvim_exec_autocmds("User", { pattern = pattern .. "Defaults", modeline = false })
    end
    _load("config." .. name)
    if vim.bo.filetype == "lazy" then
        -- HACK: gvimconf.utils may have overwritten options of the Lazy ui, so reset this here
        vim.cmd([[do VimResized]])
    end
    vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

M.did_init = false
function M.init()
    if M.did_init then
        return
    end
    M.did_init = true
    local plugin = require("lazy.core.config").spec.plugins.gvimconf.utils
    if plugin then
        vim.opt.rtp:append(plugin.dir)
    end

    package.preload["plugin.lsp.format"] = function()
        gvimconf.utils.deprecate([[require("plugin.lsp.format")]], [[gvimconf.utils.format]])
        return gvimconf.utils.format
    end

    -- delay notifications till vim.notify was replaced or after 500ms
    gvimconf.utils.lazy_notify()

    -- load options here, before lazy init while sourcing plugin modules
    -- this is needed to make sure options will be correctly applied
    -- after installing missing plugins
    M.load("options")
    -- defer built-in clipboard handling: "xsel" and "pbcopy" can be slow
    lazy_clipboard = vim.opt.clipboard
    vim.opt.clipboard = ""

    if vim.g.deprecation_warnings == false then
        vim.deprecate = function() end
    end

    gvimconf.utils.plugin.setup()
    M.json.load()
end


setmetatable(M, {
    __index = function(_, key)
        if options == nil then
            return vim.deepcopy(defaults)[key]
        end
        ---@cast options VimConfig
        return options[key]
    end,
})

return M

