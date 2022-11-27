" ***** Plug Plugin Manager *****
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'ycm-core/YouCompleteMe'
Plug 'mxw/vim-jsx'
Plug 'StanAngeloff/php.vim'
Plug 'beanworks/vim-phpfmt'
Plug 'vim-utils/vim-man'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'rfratto/vim-go-testify'
Plug 'hashivim/vim-terraform'
call plug#end()
