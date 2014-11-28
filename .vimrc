set mouse-=a
syntax on
if has('gui_running')
    set background=dark
else
    set background=dark
endif
colorscheme grb256
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
set nocp
set foldmethod=indent
set foldlevel=99
filetype plugin indent on
