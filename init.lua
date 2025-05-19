-- Basic
vim.opt.number = true

-- Copy and Paste
vim.opt.clipboard = "unnamedplus"

vim.keymap.set('n', '<C-c>', 'y', { noremap = true })
vim.keymap.set('v', '<C-c>', 'y', { noremap = true })
vim.keymap.set('n', '<C-v>', '"+p', { noremap = true })
vim.keymap.set('v', '<C-v>', '"+p', { noremap = true })

-- Package Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Install packages
require("lazy").setup({
  -- Configuring LSP
  "neovim/nvim-lspconfig",

  -- Auto-completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip", -- For `vsnip` users
      "hrsh7th/vim-vsnip"
    }
  },

  -- Termainal
  {
    'akinsho/toggleterm.nvim', version = "*", config = true
  }
})

-- Configuring LSP
local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')

-- Auto-completion
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- Snippet support
  }, {
    { name = 'buffer' },
  })
})

-- toggleterm
require("toggleterm").setup{}
