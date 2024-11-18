return {
    recommended = function()
        return gvimconf.utils.extras.wants({
            ft = "vue",
            root = { "vue.config.js" },
        })
    end,

    -- depends on the typescript extra
    { import = "plugin.extra.lang.typescript" },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "vue", "css" } },
    },

    -- Add LSP servers
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                volar = {
                    init_options = {
                        vue = {
                            hybridMode = true,
                        },
                    },
                },
                vtsls = {},
            },
        },
    },

    -- Configure tsserver plugin
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            table.insert(opts.servers.vtsls.filetypes, "vue")
            gvimconf.utils.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
                {
                    name = "@vue/typescript-plugin",
                    location = gvimconf.utils.get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
                    languages = { "vue" },
                    configNamespace = "typescript",
                    enableForWorkspaceTypeScriptVersions = true,
                },
            })
        end,
    },
}
