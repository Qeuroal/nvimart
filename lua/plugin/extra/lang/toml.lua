return {
    recommended = function()
        return gvimconf.utils.extras.wants({
            ft = "toml",
            root = "*.toml",
        })
    end,
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            taplo = {},
        },
    },
}
