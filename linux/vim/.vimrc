:set nocompatible
:syntax on
:set hlsearch
:set incsearch
:colorscheme darkblue
" NOTE THAT THIS IS COMMENT. Here we do not use # for comments, instead only one quote ;)
"map command below is used to create a shortcut of CTRL+A in order to select all text in a file
" After selection you need to use yy to yank (copy) selected text. Then use p to paste it.
map <C-a> <esc>ggVG<CR>

au bufnewfile *.sh 0r /root/.vim/.sh_header.templ
au bufnewfile *.py 0r /root/.vim/.py_header.templ
