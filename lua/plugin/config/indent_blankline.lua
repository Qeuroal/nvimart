local M = {}

function M.opts()
    return {
        exclude = {
            filetypes = {
                "dashboard",
                "terminal",
                "help",
                "log",
                "markdown",
                "TelescopePrompt",
                "lsp-installer",
                "lspinfo",
            },
        },
    }
end

return M


