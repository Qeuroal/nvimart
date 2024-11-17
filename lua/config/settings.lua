local M = {}

-- gvimconf picker to use.
-- Can be one of: telescope, fzf
-- Leave it to "auto" to automatically use the picker
-- enabled with `:LazyExtras`
vim.g.gvimconf_picker = "auto"

-- {{{> load default options
M.loadBasicOptions = function()
    local options = {
        backup = false,             -- creates a backup file
        clipboard = "unnamedplus",  -- allows neovim to access the system clipboard
        cmdheight = 1,              -- more space in the neovim command line for displaying messages
        completeopt = { "menu", "menuone", "noselect" },
        conceallevel = 0,           -- so that `` is visible in markdown files
        fileencoding = "utf-8",     -- the encoding written to a file
        foldmethod = "manual",      -- folding, set to "expr" for treesitter based folding
        foldexpr = "",              -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
        hidden = true,              -- required to keep multiple buffers and open multiple buffers
        hlsearch = true,            -- highlight all matches on previous search pattern
        ignorecase = true,          -- ignore case in search patterns
        mouse = "",                 -- allow the mouse to be used in neovim
        guicursor = "a:block",      -- set block for any mode
        pumheight = 10,             -- pop up menu height
        showmode = true,           -- we do not need to see things like "INSERT" anymore
        smartcase = true,           -- smart case
        splitbelow = true,          -- force all horizontal splits to go below current window
        splitright = true,          -- force all vertical splits to go to the right of current window
        swapfile = false,           -- creates a swapfile
        termguicolors = true,       -- set term gui colors (most terminals support this)
        timeoutlen = 1000,          -- time to wait for a mapped sequence to complete (in milliseconds)
        title = true,               -- set the title of window to the value of the titlestring
        -- opt.titlestring = "%<%F%=%l/%L - nvim"   -- what the title of the window will be set to
        undodir = undodir,          -- set an undo directory
        undofile = true,            -- enable persistent undo
        updatetime = 100,           -- faster completion
        writebackup = false,        -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
        expandtab = true,           -- convert tabs to spaces
        shiftwidth = 4,             -- the number of spaces inserted for each indentation
        tabstop = 4,                -- insert 4 spaces for a tab
        cursorline = true,          -- highlight the current line
        number = true,              -- set numbered lines
        numberwidth = 4,            -- set number column width to 2 {default 4}
        signcolumn = "yes",         -- always show the sign column, otherwise it would shift the text each time
        wrap = true,                -- display lines as one long line
        -- shadafile = join_paths(get_cache_dir(), "lvim.shada"),
        scrolloff = 0,              -- minimal number of screen lines to keep above and below the cursor.
        sidescrolloff = 0,          -- minimal number of screen lines to keep left and right of the cursor.
        showcmd = true,
        ruler = false,
        laststatus = 3,
        virtualedit = "block,onemore",
    }
    -- load option
    for k, v in pairs(options) do
        vim.opt[k] = v
    end
end
-- <}}}

-- {{{> load condition options
-- M.loadConditionOptions = function()
-- end
-- <}}}


-- {{{> 加载默认配置
M.loadDefaultConfig = function()
    M.loadBasicOptions()
    -- M.loadConditionOptions()
end
-- <}}}

return M
