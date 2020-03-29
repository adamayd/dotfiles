" enable syntax processing
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

set showmatch       " matches []{}()
highlight MatchParen cterm=underline ctermbg=none ctermfg=red
" sets the paren/bracket/brace matches to a red underline
set scrolloff=10    " sets the context lines above and below the cursor
" set scrolloff=999   " sets the cursor to stay in the middle of the screen

set incsearch       " search as characters are entered
set hlsearch        " highlights matches
" removes highlighted matches with leader ns
nnoremap <leader>ns :nohlsearch<CR>

set nobackup        " no backup files
set nowritebackup   " only in case you don't want a backup file while editing
set noswapfile      " no swap files

set foldenable      " enable folding
set foldlevelstart=99 " sets level of foldes to open
" 99 is all folds open, 10 is good for deep nesting, 0 is all folds closed
set foldnestmax=10  " sets the deepest level of nests allowed
set foldmethod=indent " sets the identifier of the folds

" ***** Word Handling *****
" makes daw and ciw accept dash separated words as one word
set iskeyword+=-

" ***** Keyboard Mappings *****
" Moving Between Windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" ***** Vundle Plugin Manager *****
set nocompatible    " be improved, required for Vundle
filetype off        " required for Vundle

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plugin 'tpope/vim-fugitive'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'morhetz/gruvbox'
Plugin 'mxw/vim-jsx'
Plugin 'godlygeek/tabular' " must be before vim-markdown
call vundle#end()

" ***** Turn back on filetype after Vundle *****
filetype plugin indent on
" enables filetype detection (on) filetype specific plugins (plugin)
" and filetype specific identation rules (ident)
" ident files located ~/.vim/indent/*.vim
" i.e. ~/.vim/indent/python.vim loads with *.py

colorscheme gruvbox
set background=dark 

" ***** NERDTree Options *****
" Starts with NERDTree open if no file is passed on command line
function! StartUp()
  if 0 == argc()
    NERDTree
  end
endfunction
autocmd VimEnter * call StartUp()

let NERDTreeQuitOnOpen=1  " closes NERDTree when file is opened
" shortcut to run NERDTree
nmap <leader><space> :NERDTreeToggle<cr>     

" ***** Powerline Plugin *****
set rtp+=~/.local/lib/python3.7/site-packages/powerline/bindings/vim/
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

