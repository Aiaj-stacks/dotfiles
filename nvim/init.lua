-- ~/.config/nvim/init.lua

-- Basic sensible defaults
vim.opt.number = true          -- show line numbers
vim.opt.relativenumber = true  -- relative numbers (great for jumps like 5j, 3k)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus" -- share clipboard with system

-- Leader key (used for custom shortcuts later)
vim.g.mapleader = " "

-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin list (empty for now, we'll add here next)
require("lazy").setup({
  -- plugins go here
})
