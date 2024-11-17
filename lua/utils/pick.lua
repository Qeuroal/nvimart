
---@class utils.pick
---@overload fun(command:string, opts?:utils.pick.Opts): fun()
local M = setmetatable({}, {
    __call = function(m, ...)
        return m.wrap(...)
    end,
})

---@class utils.pick.Opts: table<string, any>
---@field root? boolean
---@field cwd? string
---@field buf? number
---@field show_untracked? boolean

---@class Picker
---@field name string
---@field open fun(command:string, opts?:utils.pick.Opts)
---@field commands table<string, string>

---@type Picker?
M.picker = nil

---@param picker Picker
function M.register(picker)
    -- this only happens when using :LazyExtras
    -- so allow to get the full spec
    if vim.v.vim_did_enter == 1 then
        return true
    end

    if M.picker and M.picker.name ~= M.want() then
        M.picker = nil
    end

    if M.picker and M.picker.name ~= picker.name then
        gvimconf.utils.warn(
            "`gvimconf.utils.pick`: picker already set to `" .. M.picker.name .. "`,\nignoring new picker `" .. picker.name .. "`"
        )
        return false
    end
    M.picker = picker
    return true
end

function M.want()
    vim.g.gvimconf_picker = vim.g.gvimconf_picker or "auto"
    if vim.g.gvimconf_picker == "auto" then
        return gvimconf.utils.has_extra("editor.fzf") and "fzf" or "telescope"
    end
    return vim.g.gvimconf_picker
end

---@param command? string
---@param opts? utils.pick.Opts
function M.open(command, opts)
    if not M.picker then
        return gvimconf.utils.error("gvimconf.utils.pick: picker not set")
    end

    command = command ~= "auto" and command or "files"
    opts = opts or {}

    opts = vim.deepcopy(opts)

    if type(opts.cwd) == "boolean" then
        gvimconf.utils.warn("gvimconf.utils.pick: opts.cwd should be a string or nil")
        opts.cwd = nil
    end

    if not opts.cwd and opts.root ~= false then
        opts.cwd = gvimconf.utils.root({ buf = opts.buf })
    end

    command = M.picker.commands[command] or command
    M.picker.open(command, opts)
end

---@param command? string
---@param opts? utils.pick.Opts
function M.wrap(command, opts)
    opts = opts or {}
    return function()
        gvimconf.utils.pick.open(command, vim.deepcopy(opts))
    end
end

function M.config_files()
    return M.wrap("files", { cwd = vim.fn.stdpath("config") })
end

return M
