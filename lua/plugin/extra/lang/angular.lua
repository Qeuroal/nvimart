return {
    recommended = function()
        return gvimconf.utils.extras.wants({
            root = {
                "angular.json",
                "nx.json", --support for nx workspace
            },
        })
    end,

    {
        "nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "angular", "scss" })
            end
            vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
                pattern = { "*.component.html", "*.container.html" },
                callback = function()
                    vim.treesitter.start(nil, "angular")
                end,
            })
        end,
    },

    -- angularls depends on typescript
    { import = "plugin.extra.lang.typescript" },

    -- LSP Servers
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                angularls = {},
            },
            setup = {
                angularls = function()
                    gvimconf.utils.lsp.on_attach(function(client)
                        --HACK: disable angular renaming capability due to duplicate rename popping up
                        client.server_capabilities.renameProvider = false
                    end, "angularls")
                end,
            },
        },
    },

    -- Configure tsserver plugin
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            gvimconf.utils.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
                {
                    name = "@angular/language-server",
                    location = gvimconf.utils.get_pkg_path("angular-language-server", "/node_modules/@angular/language-server"),
                    enableForWorkspaceTypeScriptVersions = false,
                },
            })
        end,
    },

    -- formatting
    {
        "conform.nvim",
        opts = function(_, opts)
            if gvimconf.utils.has_extra("formatting.prettier") then
                opts.formatters_by_ft = opts.formatters_by_ft or {}
                opts.formatters_by_ft.htmlangular = { "prettier" }
            end
        end,
    },
}
