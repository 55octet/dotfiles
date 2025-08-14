autocmd BufNewFile,BufReadPost * if &filetype == "yaml" | set expandtab shiftwidth=2 indentkeys-=0# | endif

silent! autocmd! filetypedetect BufRead,BufNewFile *.tf
autocmd BufRead,BufNewFile *.hcl set filetype=hcl
autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl
autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform
autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json
autocmd BufWritePre *.py call BlackSync()


"set termguicolors
"set laststatus=2

if !has('gui_running')
  set t_Co=256
endif

lua << EOF

local home = os.getenv("HOME")

vim.g.python3_host_prog = home .. "/.local/venv/nvim/bin/python"

vim.g.terraform_fmt_on_save=1
vim.g.terraform_align=1
vim.g.terraform_binary_path='/usr/local/bin/tofu'

vim.cmd([[
set splitbelow
set splitright
call plug#begin()
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release --locked
    else
      !cargo build --release --locked --no-default-features --features json-rpc
    endif
  endif
endfunction

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'tanvirtin/monokai.nvim'
Plug 'towolf/vim-helm'
Plug 'mrjosh/helm-ls'
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-ansible'
Plug 'itchyny/lightline.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hashivim/vim-terraform'
Plug 'farmergreg/vim-lastplace'
Plug 'tpope/vim-fugitive'
Plug 'HiPhish/rainbow-delimiters.nvim'
" Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'averms/black-nvim', {'do': ':UpdateRemotePlugins'}
Plug 'pedrohdz/vim-yaml-folds'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'diogo464/kubernetes.nvim'

call plug#end()
]])

require('monokai').setup({ 
    palette = require('monokai').pro,
    italics = false,
})

--local highlight = {
--    "RainbowRed",
--    "RainbowYellow",
--    "RainbowBlue",
--    "RainbowOrange",
--    "RainbowGreen",
--    "RainbowViolet",
--    "RainbowCyan",
--}

--hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
--    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
--    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
--    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
--    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
--    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
--    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
--    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
--end)

local highlight = {
    "DarkGrey",
    "DarkGreyish",
    "Grey",
    "Greyish",
    "LightGrey",
    "LightGreyish",
}

local hooks = require("ibl.hooks")
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "DarkGrey", { fg = "#4E4E4E" })
    vim.api.nvim_set_hl(0, "DarkGreyish", { fg = "#5F5F5F" })
    vim.api.nvim_set_hl(0, "Grey", { fg = "#6C6C6C" })
    vim.api.nvim_set_hl(0, "Greyish", { fg = "#808080" })
    vim.api.nvim_set_hl(0, "LightGrey", { fg = "#8A8A8A" })
    vim.api.nvim_set_hl(0, "LightGreyish", { fg = "#9E9E9E" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }

local ibl = require("ibl")
ibl.setup({
    enabled = true,
    debounce = 100,
    scope = { highlight = highlight },
    indent = { 
        char = '┊',
        highlight = highlight,
    },
    whitespace = {
        highlight = { "Whitespace", "NonText" }
    },
})

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

vim.api.nvim_command([[setlocal spell spelllang=en_us]])
vim.api.nvim_set_keymap("", "<F2>", ":set paste! paste?<CR>", {noremap = true})
vim.api.nvim_set_keymap("i", "<F2>", "<ESC>:set paste! paste?<CR>", {noremap = true})
vim.api.nvim_set_keymap("", "<F3>", ":set number!<CR>", {noremap = true})
vim.api.nvim_set_keymap("i", "<F3>", "<ESC>:set number!<CR>", {noremap = true})
vim.keymap.set({"i", "n"}, "<F4>", "<ESC>:IBLToggle<CR>", {silent = true})
vim.keymap.set({"i", "n"}, "<F5>", "<ESC>:Neotree toggle<CR>", {silent = true})
vim.keymap.set({"i", "n"}, "<F7>", "<ESC>:bprevious<CR>", {silent = true})
vim.keymap.set({"i", "n"}, "<F8>", "<ESC>:bNext<CR>", {silent = true})
vim.keymap.set({"i", "n"}, "<F12>", ":source $MYVIMRC<CR>", {silent = true})

-- 0 is current buffer
vim.api.nvim_buf_set_keymap(0, "", "<c-q>", "<cmd>call Black()<cr>", {noremap = true, silent = true})
vim.api.nvim_buf_set_keymap(0, "i", "<c-q>", "<cmd>call Black()<cr>", {noremap = true, silent = true})

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require("lspconfig")
local kubernetes = require("kubernetes")

kubernetes.setup(
    {
        schema_strict = true,
        schema_generate_always = false,
        patch = true,
        yamlls_root = function () return "/usr/local/lib/" end,
    }
)

vim.lsp.config("helm-ls", {
    settings = {
        ["helm-ls"] = {
            yamlls = {
                path = "yaml-language-server",
            }
        }
    }
})

vim.lsp.enable("jedi_language_server")
vim.lsp.enable("ansiblels")
vim.lsp.enable("lua_ls")
vim.lsp.enable("yamlls")
vim.lsp.config("yamlls", {
    capabilities = capabilities,
    settings = {
        ["yaml"] = {
            schemas = {
                [kubernetes.yamlls_schema()] = "*.yaml",
                ["https://repo1.dso.mil/big-bang/bigbang/-/raw/master/chart/values.schema.json?ref_type=heads"] = "/*/configmap.yaml",
                ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = ".gitlab-ci.yml",
            }
        }
    }
})

lspconfig.terraformls.setup({
    capabilities = capabilities
})
lspconfig.tflint.setup({
    capabilities = capabilities
})
lspconfig.marksman.setup({})

local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
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
        { name = 'vsnip' },
        { name = 'path' },
    },
    {
        { name = 'buffer' },
    }),
})

vim.diagnostic.config({
    signs = { 
        text = { 
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN] = '⚠',
            ... 
        }
    }
})


vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach_auto_diag", { clear = true }),
    callback = function(args)
        local opts = { noremap = true, silent = true}
        vim.api.nvim_buf_set_keymap(args.buf, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        vim.api.nvim_buf_set_keymap(args.buf, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.api.nvim_buf_set_keymap(args.buf, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        vim.api.nvim_buf_set_keymap(args.buf, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)

        -- create the autocmd to show diagnostics
        vim.api.nvim_create_autocmd("CursorHold", {
            group = vim.api.nvim_create_augroup("_auto_diag", { clear = true }),
            buffer = args.buf,
            callback = function()
                local opts = {
                    focusable = false,
                    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                    border = "rounded",
                    source = "always",
                    prefix = " ",
                    scope = "cursor",
                }
                vim.diagnostic.open_float(nil, opts)
            end,
        })
    end,
})

require('nvim-treesitter.configs').setup({highlight={enable=true}})  -- At the bottom of your init.vim, keep all configs on one line
EOF

let g:lightline = {
      \ 'colorscheme': 'one', 
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'readonly': 'LightlineReadonly',
      \ },
      \ }

function! LightlineReadonly()
  return &readonly && &filetype !=# 'help' ? 'RO' : ''
endfunction

" inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

set encoding=UTF-8
set mouse-=a

set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
set number
set nocp
set foldmethod=indent
set foldlevel=99

filetype plugin indent on

" YAML configuration
augroup yaml_fix
    autocmd!
    autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab "indentkeys-=0# indentkeys-=<:>
augroup END

set list lcs=tab:\»\ 

set noshowmode
