local M = {}


function M.setup()
    local nvimTmuxNav = require('nvim-tmux-navigation')

    nvimTmuxNav.setup {
        disable_when_zoomed = true -- defaults to false
    }

    vim.keymap.set('n', "<C-h>", nvimTmuxNav.NvimTmuxNavigateLeft)
    vim.keymap.set('n', "<C-j>", nvimTmuxNav.NvimTmuxNavigateDown)
    vim.keymap.set('n', "<C-k>", nvimTmuxNav.NvimTmuxNavigateUp)
    vim.keymap.set('n', "<C-l>", nvimTmuxNav.NvimTmuxNavigateRight)
    vim.keymap.set('n', "<C-\\>", nvimTmuxNav.NvimTmuxNavigateLastActive)
    vim.keymap.set('n', "<C-Space>", nvimTmuxNav.NvimTmuxNavigateNext)
end

return M

