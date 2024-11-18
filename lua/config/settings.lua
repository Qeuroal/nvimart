local M = {}

-- gvimconf picker to use.
-- Can be one of: telescope, fzf
-- Leave it to "auto" to automatically use the picker
-- enabled with `:LazyExtras`
vim.g.gvimconf_picker = "auto"

-- LazyVim auto format
vim.g.autoformat = false

-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
vim.g.ai_cmp = true

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- Optionally setup the terminal to use
-- This sets `vim.o.shell` and does some additional configuration for:
-- * pwsh
-- * powershell
-- LazyVim.terminal.setup("pwsh")

-- Set LSP servers to be ignored when used with `util.root.detectors.lsp`
-- for detecting the LSP root
vim.g.root_lsp_ignore = { "copilot" }

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- Show the current document symbols location from Trouble in lualine
-- You can disable this for a buffer by setting `vim.b.trouble_lualine = false`
vim.g.trouble_lualine = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0


-- {{{> load default options
M.loadBasicOptions = function()
    local options = {
        backup = false,             -- creates a backup file
        -- clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
        cmdheight = 1,              -- more space in the neovim command line for displaying messages
        completeopt = { "menu", "menuone", "noselect" },
        -- conceallevel = 0,           -- so that `` is visible in markdown files
        fileencoding = "utf-8",     -- the encoding written to a file
        -- foldmethod = "manual",      -- folding, set to "expr" for treesitter based folding
        -- foldexpr = "",              -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
        hidden = true,              -- required to keep multiple buffers and open multiple buffers
        hlsearch = true,            -- highlight all matches on previous search pattern
        -- ignorecase = true,          -- ignore case in search patterns
        mouse = "",                 -- allow the mouse to be used in neovim
        guicursor = "a:block",      -- set block for any mode
        -- pumheight = 10,             -- pop up menu height
        showmode = false,           -- we do not need to see things like "INSERT" anymore
        -- smartcase = true,           -- smart case
        -- splitbelow = true,          -- force all horizontal splits to go below current window
        -- splitright = true,          -- force all vertical splits to go to the right of current window

        swapfile = false,           -- creates a swapfile
        termguicolors = true,       -- set term gui colors (most terminals support this)
        timeoutlen = vim.g.vscode and 1000 or 300, -- Lower than default (1000) to quickly trigger which-key
        title = true,               -- set the title of window to the value of the titlestring
        -- opt.titlestring = "%<%F%=%l/%L - nvim"   -- what the title of the window will be set to
        undodir = undodir,          -- set an undo directory
        undofile = true,            -- enable persistent undo
        updatetime = 100,           -- faster completion
        writebackup = false,        -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
        -- expandtab = true,           -- convert tabs to spaces
        shiftwidth = 4,             -- the number of spaces inserted for each indentation
        tabstop = 4,                -- insert 4 spaces for a tab
        -- cursorline = true,          -- highlight the current line
        -- number = true,              -- set numbered lines
        numberwidth = 4,            -- set number column width to 2 {default 4}
        -- signcolumn = "yes",         -- always show the sign column, otherwise it would shift the text each time
        wrap = true,                -- display lines as one long line
        -- shadafile = join_paths(get_cache_dir(), "lvim.shada"),
        scrolloff = 0,              -- minimal number of screen lines to keep above and below the cursor.
        sidescrolloff = 0,          -- minimal number of screen lines to keep left and right of the cursor.
        showcmd = true,
        -- ruler = false,
        -- laststatus = 3,
        virtualedit = "block,onemore",


        autowrite = true, -- Enable auto write
        -- only set clipboard if not in ssh, to make sure the OSC 52
        -- integration works automatically. Requires Neovim >= 0.10.0
        clipboard = vim.env.SSH_TTY and "" or "unnamedplus", -- Sync with system clipboard
        -- completeopt = "menu,menuone,noselect",
        conceallevel = 2, -- Hide * markup for bold and italic, but not markers with substitutions
        confirm = true, -- Confirm to save changes before exiting modified buffer
        cursorline = true, -- Enable highlighting of the current line
        expandtab = true, -- Use spaces instead of tabs
        fillchars = {
            foldopen = "",
            foldclose = "",
            fold = " ",
            foldsep = " ",
            diff = "╱",
            eob = " ",
        },
        foldlevel = 99,
        formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()",
        formatoptions = "jcroqlnt", -- tcqj
        grepformat = "%f:%l:%c:%m",
        -- grepprg = "rg, --vimgrep",
        ignorecase = true, -- Ignore case
        inccommand = "nosplit", -- preview incremental substitute
        jumpoptions = "view",
        laststatus = 3, -- global statusline
        linebreak = true, -- Wrap lines at convenient points
        list = false, -- Show some invisible characters (tabs...
        number = true, -- Print line number
        pumblend = 10, -- Popup blend
        pumheight = 10, -- Maximum number of entries in a popup
        relativenumber = true, -- Relative line numbers
        ruler = false, -- Disable the default ruler
        -- scrolloff = 4, -- Lines of context
        sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },
        shiftround = true, -- Round indent
        -- shiftwidth = 2, -- Size of an indent
        -- showmode = false, -- Dont show mode since we have a statusline
        -- sidescrolloff = 8, -- Columns of context
        signcolumn = "yes", -- Always show the signcolumn, otherwise it would shift the text each time
        smartcase = true, -- Don't ignore case with capitals
        smartindent = true, -- Insert indents automatically
        spelllang = { "en" },
        splitbelow = true, -- Put new windows below current
        splitkeep = "screen",
        splitright = true, -- Put new windows right of current
        statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]],
        -- tabstop = 2, -- Number of spaces tabs count for
        -- termguicolors = true, -- True color support
        -- timeoutlen = vim.g.vscode and 1000 or 300, -- Lower than default (1000) to quickly trigger which-key
        -- undofile = true,
        undolevels = 10000,
        -- updatetime = 200, -- Save swap file and trigger CursorHold
        -- virtualedit = "block", -- Allow cursor to move where there is no text in visual block mode
        wildmode = "longest:full,full", -- Command-line completion mode
        winminwidth = 5, -- Minimum window width
        -- wrap = false, -- Disable line wrap
        listchars = {
            eol = '⤶',
            space = '_',
            trail = '✚',
            extends = '◀',
            precedes = '▶',
        }


    }
    -- load option
    for k, v in pairs(options) do
        vim.opt[k] = v
    end

    if vim.fn.has("nvim-0.10") == 1 then
        vim.opt.smoothscroll = true
        vim.opt.foldexpr = "v:lua.require'utils'.ui.foldexpr()"
        vim.opt.foldmethod = "expr"
        vim.opt.foldtext = ""
    else
        vim.opt.foldmethod = "indent"
        vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
    end
    vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
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
