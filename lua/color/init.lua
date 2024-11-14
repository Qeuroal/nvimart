-- define your colorscheme here
local colorscheme = 'onedark'

local isOk, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not isOk then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
    return
end
