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

" Plug 'phanviet/vim-monokai-pro'
Plug 'tanvirtin/monokai.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
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
" Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
" Plug 'psf/black', { 'branch': 'stable' }
Plug 'Yggdroot/indentLine'
" Plug 'dense-analysis/ale'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'preservim/nerdtree'

call plug#end()

autocmd BufNewFile,BufReadPost * if &filetype == "yaml" | set expandtab shiftwidth=2 indentkeys-=0# | endif

silent! autocmd! filetypedetect BufRead,BufNewFile *.tf
autocmd BufRead,BufNewFile *.hcl set filetype=hcl
autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl
autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform
autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json


"set termguicolors
"set laststatus=2

if !has('gui_running')
  set t_Co=256
endif

lua << EOF

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

lspconfig.terraformls.setup{
    capabilities = capabilities
}
lspconfig.tflint.setup{
    capabilities = capabilities
}
lspconfig.yamlls.setup{
    capabilities = capabilities,
    settings = {
        yaml = {
            schemas = {
                ["https://repo1.dso.mil/big-bang/bigbang/-/raw/master/chart/values.schema.json?ref_type=heads"] = "/*/configmap.yaml",
            }
        }
    }
}


require'nvim-treesitter.configs'.setup{highlight={enable=true}}  -- At the bottom of your init.vim, keep all configs on one line

require('monokai').setup({ 
    palette = require('monokai').pro,
    italics = false,
})

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

nnoremap <F2> :set paste! paste?<CR>
nnoremap <F3> :set number!<CR>
map <F4> :IndentLinesToggle<CR>
map <F5> :NERDTreeToggle<CR>
map <F7> :tabp<CR>
map <F8> :tabn<CR>
map <F12> :source $MYVIMRC<CR>

" YAML configuration
augroup yaml_fix
    autocmd!
    autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab "indentkeys-=0# indentkeys-=<:>
augroup END

let g:indentLine_char = '⦙'
set list lcs=tab:\»\ 

" let g:ale_disable_lsp='auto'
" let g:ale_use_neovim_diagnostics_api=1
" let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" let g:ale_sign_error = '✘'
" let g:ale_sign_warning = '⚠'
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_use_neovim_diagnostics_api = 1

let g:terraform_fmt_on_save=1
let g:terraform_align=1
let g:terraform_binary_path='/usr/local/bin/tofu'

set noshowmode
