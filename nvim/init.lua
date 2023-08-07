-- Plugins
----------
vim.cmd.packadd('packer.nvim')
require 'plugins'

-- Sensible defaults
--------------------
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamed'
vim.opt.termguicolors = true
vim.opt.splitright = true
vim.opt.expandtab = true
-- Disable comment continuation in insert mode
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
        vim.opt.formatoptions:remove { 'c', 'r', 'o' }
    end
})

-- Layout
---------
require 'theme'

-- LSP
------
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({ buffer = bufnr })
    lsp.buffer_autoformat()
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

-- Treesitter
-------------

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*.js",
    callback = function()
        vim.cmd 'set filetype=typescript'
    end
})

require('nvim-treesitter.configs').setup {
    ensure_installed = { "rust", "typescript", "javascript", "tsx", "lua", "vim", "vimdoc", "query", "java" },
    highlight = {
        enabled = true
    }
}

-- Key bindings
---------------
local telescope = require 'telescope.builtin'
vim.g.mapleader = ' '
local function nnoremap(key, val)
    vim.keymap.set('n', key, val, { remap = false })
end

nnoremap('øe', ':e $MYVIMRC<CR>')
nnoremap('øp', ':e ~/.config/nvim/lua/plugins.lua<CR>')
nnoremap('øt', ':e ~/.config/nvim/lua/theme.lua<CR>')
nnoremap('øø', ':w<CR>')
-- nnoremap('øf', ':NeoFormat')
nnoremap('<C-o>', telescope.find_files)
nnoremap('øf', telescope.find_files)
nnoremap('<Leader>f', telescope.find_files)
nnoremap('<C-f>', telescope.live_grep)
vim.keymap.set('n', 'øs', ':call SynStack()<CR>', { remap = false })

-- Misc
-------
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = "theme.lua",
    callback = function()
        vim.cmd 'so %'
    end
})

vim.cmd [[
	function! SynStack()
	  if !exists("*synstack")
		return
	  endif
	  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
	endfunc
]]

local cmp = require 'cmp'

cmp.setup {
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    }),
}
