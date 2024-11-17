if lazyvim_docs then
    -- In case you don't want to use `:LazyExtras`,
    -- then you need to set the option below.
    vim.g.gvimconf_picker = "telescope"
end

local build_cmd ---@type string?
for _, cmd in ipairs({ "make", "cmake", "gmake" }) do
    if vim.fn.executable(cmd) == 1 then
        build_cmd = cmd
        break
    end
end

---@type LazyPicker
local picker = {
    name = "telescope",
    commands = {
        files = "find_files",
    },
    -- this will return a function that calls telescope.
    -- cwd will default to utils.get_root
    -- for `files`, git_files or find_files will be chosen depending on .git
    ---@param builtin string
    ---@param opts? utils.pick.Opts
    open = function(builtin, opts)
        opts = opts or {}
        opts.follow = opts.follow ~= false
        if opts.cwd and opts.cwd ~= vim.uv.cwd() then
            local function open_cwd_dir()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                gvimconf.utils.pick.open(
                    builtin,
                    vim.tbl_deep_extend("force", {}, opts or {}, {
                        root = false,
                        default_text = line,
                    })
                )
            end
            ---@diagnostic disable-next-line: inject-field
            opts.attach_mappings = function(_, map)
                -- opts.desc is overridden by telescope, until it's changed there is this fix
                map("i", "<a-c>", open_cwd_dir, { desc = "Open cwd Directory" })
                return true
            end
        end

        require("telescope.builtin")[builtin](opts)
    end,
}
if not gvimconf.utils.pick.register(picker) then
    return {}
end




local M = {}

function M.dependencies()
    return {
        "nvim-lua/plenary.nvim",
        "LinArcX/telescope-env.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && "
                .. "cmake --build build --config Release && "
                .. "cmake --install build --prefix build",
        },
    }
end

function M.opts()
    local actions = require("utils.modules").requireOnExportedCall "telescope.actions"
    return {
        ---@usage disable telescope completely [not recommended]
        active = true,
        on_config_done = nil,
        theme = "dropdown", ---@type telescope_themes
        defaults = {
            prompt_prefix = gvimconf.config.icons.ui.Telescope .. " ",
            selection_caret = gvimconf.config.icons.ui.Forward .. " ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = nil,
            layout_strategy = nil,
            layout_config = {},
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--hidden",
                "--glob=!.git/",
            },
            ---@usage Mappings are fully customizable. Many familiar mapping patterns are setup as defaults.
            mappings = {
                i = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-c>"] = actions.close,
                    ["<C-n>"] = actions.cycle_history_next,
                    ["<C-p>"] = actions.cycle_history_prev,
                    ["<C-q>"] = function(...)
                        actions.smart_send_to_qflist(...)
                        actions.open_qflist(...)
                    end,
                    ["<CR>"] = actions.select_default,
                },
                n = {
                    ["<C-n>"] = actions.move_selection_next,
                    ["<C-p>"] = actions.move_selection_previous,
                    ["<C-c>"] = actions.close,
                    ["<C-q>"] = function(...)
                        actions.smart_send_to_qflist(...)
                        actions.open_qflist(...)
                    end,
                },
            },
            file_ignore_patterns = {},
            path_display = { "smart" },
            winblend = 0,
            border = {},
            borderchars = nil,
            color_devicons = true,
            set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        },
        pickers = {
            find_files = {
                hidden = true,
            },
            live_grep = {
                --@usage don't include the filename in the search results
                only_sort_text = true,
            },
            grep_string = {
                only_sort_text = true,
            },
            buffers = {
                initial_mode = "normal",
                mappings = {
                    i = {
                        ["<C-d>"] = actions.delete_buffer,
                    },
                    n = {
                        ["dd"] = actions.delete_buffer,
                    },
                },
            },
            planets = {
                show_pluto = true,
                show_moon = true,
            },
            git_files = {
                hidden = true,
                show_untracked = true,
            },
            colorscheme = {
                enable_preview = true,
            },
        },
        extensions = {
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            },
        },
    }
end

function M.keymapping()
    return {
        { "<leader>o", "<Cmd>Telescope find_files<CR>", desc = "find file", silent = true, noremap = true },
        { "<leader>s", "<Cmd>Telescope live_grep<CR>", desc = "live grep", silent = true, noremap = true },
        { "<leader>ue", "<Cmd>Telescope env<CR>", desc = "environment variables", silent = true, noremap = true },
    }
end

function M.setup(_, opts)
    local telescope = require "telescope"
    telescope.setup(opts)
    telescope.load_extension "fzf"
    telescope.load_extension "env"
end

return M

