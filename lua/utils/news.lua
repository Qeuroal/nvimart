---@class utils.news
local M = {}

function M.hash(file)
    local stat = vim.uv.fs_stat(file)
    if not stat then
        return
    end
    return stat.size .. ""
end

function M.setup()
    vim.schedule(function()
        if gvimconf.config.news.vimart then
            if not gvimconf.config.json.data.news["NEWS.md"] then
                M.welcome()
            end
            M.vimart(true)
        end
        if gvimconf.config.news.neovim then
            M.neovim(true)
        end
    end)
end

function M.welcome()
    gvimconf.utils.info("Welcome to NVIMART!")
end

function M.changelog()
    M.open("CHANGELOG.md", { plugin = "lazy.nvim" })
end

function M.vimart(when_changed)
    M.open("NEWS.md", { plugin = "lazy.nvim", when_changed = when_changed })
end

function M.neovim(when_changed)
    M.open("doc/news.txt", { rtp = true, when_changed = when_changed })
end

---@param file string
---@param opts? {plugin?:string, rtp?:boolean, when_changed?:boolean}
function M.open(file, opts)
    local ref = file
    opts = opts or {}
    if opts.plugin then
        local plugin = require("lazy.core.config").plugins[opts.plugin] --[[@as LazyPlugin?]]
        if not plugin then
            return gvimconf.utils.error("plugin not found: " .. opts.plugin)
        end
        file = plugin.dir .. "/" .. file
    elseif opts.rtp then
        file = vim.api.nvim_get_runtime_file(file, false)[1]
    end

    if not file then
        return gvimconf.utils.error("File not found")
    end

    if opts.when_changed then
        local is_new = not gvimconf.config.json.data.news[ref]
        local hash = M.hash(file)
        if hash == gvimconf.config.json.data.news[ref] then
            return
        end
        gvimconf.config.json.data.news[ref] = hash
        gvimconf.utils.json.save()
        -- don't open if file has never been opened
        if is_new then
            return
        end
    end

    Snacks.config.style("news", {
        width = 0.6,
        height = 0.6,
        wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
        },
    })

    local float = Snacks.win({
        file = file,
        style = "news",
    })

    if vim.diagnostic.enable then
        pcall(vim.diagnostic.enable, false, { bufnr = float.buf })
    else
        pcall(vim.diagnostic.disable, float.buf)
    end
end

return M
