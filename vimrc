syntax enable		    " enable syntax processing
if !exists("g:syntax_on")
    syntax enable
endif

set tabstop=2	    	" number of visual spaces per TAB
set softtabstop=2 	" number of spaces in tab when editing
set expandtab   		" turns tabs into number of spaces
set shiftwidth=2    " sets the space on autoindents
" set autoindent      " copies indentation from previous line

set number          " show line numbers
set relativenumber  " show line number relative to current line
set cursorline      " highline line number of current line
"set lazyredraw      " redraws only when needed

filetype plugin indent on
" enables filetype detection (on) filetype specific plugins (plugin)
" and filetype specific identation rules (ident)
" ident files located ~/.vim/indent/*.vim
" i.e. ~/.vim/indent/python.vim loads with *.py

set showmatch       " matches []{}()
highlight MatchParen cterm=underline ctermbg=none ctermfg=red
" sets the paren/bracket/brace matches to a red underline
set scrolloff=10    " sets the context lines above and below the cursor
" set scrolloff=999   " sets the cursor to stay in the middle of the screen

set incsearch       " search as characters are entered
set hlsearch        " highlights matches
nnoremap <leader><space> :nohlsearch<CR>
" removes highlighted matches with ,<space>

set nobackup        " no backup files
set nowritebackup   " only in case you don't want a backup file while editing
set noswapfile      " no swap files

set foldenable      " enable folding
set foldlevelstart=99 " sets level of foldes to open
" 99 is all folds open, 10 is good for deep nesting, 0 is all folds closed
set foldnestmax=10  " sets the deepest level of nests allowed
set foldmethod=indent " sets the identifier of the folds

"execute pathogen#infect()
" launch pathogen plugin manager

" netrw settings
let g:netrw_banner = 0            " removes the info banner
let g:netrw_liststyle = 3         " sets the viewing style to tree
let g:netrw_browse_split = 4      " sets selection to open in same window (same as netrw)
let g:netrw_altv = 1              " 
let g:netrw_winsize = 20          " sets the browser window size to 20%
nmap <leader>ne :Vexplore<cr>     " shortcut to run netrw
nmap <leader>nt :NERDTree<cr>     " shortcut to run NERDTree

"autocmd!      
"autocmd VimEnter * :Vexplore

" ***** Word Handling *****
" makes daw and ciw accept dash separated words as one word
set iskeyword+=-

" ***** Keyboard Mappings *****
" Moving Between Windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" ***** Plug Plugin Manager *****
" Check for Plug installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
call plug#end()

" ***** Powerline Plugin *****
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
