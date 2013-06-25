""""""""""""""""""""""""""""""""""""""""""""""
"" general setup
"""""--------------------------------------{{{

filetype off
call pathogen#infect()
syntax on
filetype plugin indent on
set nocompatible
set visualbell
set encoding=utf-8
set hidden
set viminfo='1000,f1,<500,:100,@100,/100
set noswapfile
set autowrite
set nowrap

"""""------------------||------------------}}}
"" end: general setup
""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""
"" visual
"""""--------------------------------------{{{

set hlsearch
set background=light
"-- ------------------------------------[ colors ]---{{{
" colorscheme 256-jungle
" colorscheme beauty256
" colorscheme blacklight
" colorscheme busierbee
colorscheme candyman
" colorscheme donbass

"-- |--------------- |
"-- |  TODO | colors |
"-- ------[ a7628695-dfdc-49cd-8f1d-a29069765937 ]---}}}

" colorscheme cthulhian
" colorscheme oceandeep
" colorscheme rainbow_fruit
" colorscheme soso
" colorscheme rainbow_fine_blue
" colorscheme devbox-dark-256
" colorscheme wombat
" colorscheme beachcomber
set nocursorline
set autochdir
if has("gui_running")
    if has("gui_gtk")
        :set guifont=Terminus\ 13
    elseif has("x11")
    " Also for GTK 1
        :set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
    elseif has("gui_win32")
        :set guifont=Luxi_Mono:h12:cANSI
    endif
endif
nnoremap <leader><space> :noh<cr>
set foldmethod=marker
set foldtext=foldtext()
function! MyFoldText()
    let line = getline(v:foldstart)
    let foo = line 
    substitute(foo, '[^[:alnum:]]', '', 'g')
    return v:folddashes . foo
endfunction

"""""--------------------------------------}}}
"" end: visual
""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""
"" layout
"""""--------------------------------------{{{

set tabstop=8
set expandtab
set softtabstop=4
set shiftwidth=4
set smarttab
set shiftround
set nojoinspaces
set autoindent

"""""------------------||------------------}}}
"" end: layout
""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""
"" UI
"""""--------------------------------------{{{

set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=r
set guioptions-=b
set showmode
set showcmd
set wildmode=list:longest
set wildmenu
set ttyfast
set ruler
set laststatus=2
set relativenumber
let g:showmarks_enable=1
fun! RangerChooser()
    exec "silent !ranger --choosefile=/tmp/chosenfile " . expand("%:p:h")
    if filereadable('/tmp/chosenfile')
        exec 'edit ' . system('cat /tmp/chosenfile')
        call system('rm /tmp/chosenfile')
    endif
    redraw!
endfun
map <leader>r :call RangerChooser()<CR>
"""""------------------||------------------}}}
"" end: UI
""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""
"" convenience and maps
"""""--------------------------------------{{{

nnoremap / /\v
vnoremap / /\v
nnoremap <leader>f :let @@ = expand("%:p")<cr>
nnoremap <F5> :set spell! spelllang=en_us<CR>


"""""------------------||------------------}}}
"" end: convenience and maps
""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" plugins
"""""----------------------------------------------------------------{{{

"""""""""
"" tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>

"""""""""
"" nerd commenter
let g:NERDSpaceDelims=1
let g:NERDCustomDelimiters={
    \    'zsh': { 'left': '#', 'leftAlt': '#', 'rightAlt': 
    \    '##-##', 'right': '' }
    \}


"""""""""
"" haskell mode
" au BufEnter *.hs compiler ghc
autocmd FileType haskell compiler hlint
let g:haskell_autotags=1
let g:haskell_tags_generator="hasktags"
let g:haddock_browser="/usr/bin/chromium"
let g:haddock_docdir="/home/dave/code/doc/haskell/libraries"
let g:haddock_indexfiledir="/home/dave/.haddock_index"

"""""-------------|d897500e-27eb-45b9-8847-31eb1cbf3f4f|-------------}}}
"" end: plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
