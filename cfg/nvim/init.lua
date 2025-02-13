-- install lazy.nvim
require("setup.lazy")

local opt = vim.opt

-- options
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.termguicolors = true
opt.number = true
opt.showmode = false
opt.cmdheight = 0
opt.laststatus = 0
opt.clipboard = 'unnamedplus'
opt.mouse = 'a'
opt.autoindent = true

-- autocmds
vim.cmd [[ autocmd FileType lua setlocal tabstop=3 shiftwidth=3 expandtab ]]
vim.cmd [[ autocmd VimLeave * set guicursor=n:ver25 ]]

-- keymaps
vim.keymap.set('n', '<Tab>', '<cmd>bn!<cr>', { desc = 'Go to next buffer' })
vim.keymap.set('n', '<S-Tab>', '<cmd>bp!<cr>', { desc = 'Go to previous buffer' })
vim.keymap.set('n', '<leader>x', '<cmd>bd!<cr>', { desc = 'Close buffer' })
vim.keymap.set('n', ';', ':', { desc = 'Easily go to cmdline' })

for _, key in ipairs {'jk', 'jj', 'kj', 'kk'} do
   vim.keymap.set('i', key, '<esc>', { desc = 'Go to normal mode in insert mode' })
end

for _, key in ipairs {'h', 'j', 'k', 'l'} do
   vim.keymap.set('n', '<C-' .. key .. '>', '<C-w>' .. key, { desc = 'Move dir' })
end

-- custom commands

-- call gh repo view --web when doing :repoview
vim.api.nvim_create_user_command('RepoView', function ()
   local command = 'gh repo view --web'
   local handle = io.popen(command)
   if handle ~= nil then
      handle:close()
   end
end, {})

vim.cmd.cabbrev 'repoview RepoView'
