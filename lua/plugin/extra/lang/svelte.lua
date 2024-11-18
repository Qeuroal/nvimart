return {
    recommended = function()
        return gvimconf.utils.extras.wants({
            ft = "svelte",
            root = {
                "svelte.config.js",
                "svelte.config.mjs",
                "svelte.config.cjs",
            },
        })
    end,

    -- depends on the typescript extra
    { import = "plugin.extra.lang.typescript" },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "svelte" } },
    },

    -- LSP Servers
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                svelte = {
                    keys = {
                        {
                            "<leader>co",
                            gvimconf.utils.lsp.action["source.organizeImports"],
                            desc = "Organize Imports",
                        },
                    },
                    capabilities = {
                        workspace = {
                            didChangeWatchedFiles = vim.fn.has("nvim-0.10") == 0 and { dynamicRegistration = true },
                        },
                    },
                },
            },
        },
    },

    -- Configure tsserver plugin
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            gvimconf.utils.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
                {
                    name = "typescript-svelte-plugin",
                    location = gvimconf.utils.get_pkg_path("svelte-language-server", "/node_modules/typescript-svelte-plugin"),
                    enableForWorkspaceTypeScriptVersions = true,
                },
            })
        end,
    },

    {
        "conform.nvim",
        opts = function(_, opts)
            if gvimconf.utils.has_extra("formatting.prettier") then
                opts.formatters_by_ft = opts.formatters_by_ft or {}
                opts.formatters_by_ft.svelte = { "prettier" }
            end
        end,
    },
}
