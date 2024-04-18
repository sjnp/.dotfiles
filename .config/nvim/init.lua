-- [[ Util Func ]]
local nmap = function(keys, func, opts)
    vim.keymap.set("n", keys, func, opts)
end

local vmap = function (keys, func, opts)
    vim.keymap.set("v", keys, func, opts)
end

local imap = function (keys, func, opts)
   vim.keymap.set("i", keys, func, opts)
end

vim.g.mapleader = " "

-- [[ Lazy.nvim ]]
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazy_path,
    })
end
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}
    },
    {
        'numToStr/Comment.nvim',
        opts = {},
        lazy = false,
    },
    {
        'navarasu/onedark.nvim',
        priority = 1000,
        config = function()
            require('onedark').setup {
                style = 'darker',
            }
            require('onedark').load()
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                icons_enabled = true,
                theme = 'onedark',
                component_separators = '|',
                section_separators = '',
            },
        },
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function ()
           require('gitsigns').setup()
        end

    },
})

-- [[ Remap ]]
nmap("<leader>ex", vim.cmd.Ex, {})
imap("jk", "<Esc>", {})

-- [[ Plugin ]]
-- Telescope
local telescope_builtin = require("telescope.builtin")
nmap("<leader>sf", telescope_builtin.find_files, {})
nmap("<leader>sg", telescope_builtin.git_files, {})
nmap("<leader>ss", function ()
    telescope_builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, {})
vmap("<leader>ss", function ()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})
    text = string.gsub(text, "\n", "")
    print(text)
    if #text <= 0 then
        text = ""
    end
    telescope_builtin.grep_string ({ search = text })
end, {})

-- Treesitter
vim.defer_fn(function()
    require("nvim-treesitter.configs").setup {
        ensure_installed = { "lua", "go", "rust" },
        auto_install = false,
        highlight = {
            enable = true,
        },
    }
end, 0)

-- LSP
local servers = {
    gopls = {},
    rust_analyzer = {},
    lua_ls = {
        Lua = {
            diagnostics = { globals = {"vim"} },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

require("mason").setup()
require("mason-lspconfig").setup()
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

local on_attach = function (_, bufnr)
    local opts = { buffer = bufnr, remap = false }
    nmap("gd", vim.lsp.buf.definition, opts)
    nmap("K", vim.lsp.buf.hover, opts)
    nmap("gr", telescope_builtin.lsp_references, opts)
    nmap("gi", telescope_builtin.lsp_implementations, opts)
    nmap('<leader>rn', vim.lsp.buf.rename, opts)
end

mason_lspconfig.setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
            on_attach = on_attach,
        }
    end,
}

local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup {}
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete {},
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
}

-- Comment.nvim
require('Comment').setup()

-- [[ Set ]]
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }
