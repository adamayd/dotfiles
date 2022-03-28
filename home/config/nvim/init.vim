" enable syntax processing
if !exists("g:syntax_on")
    syntax enable
endif

" ***** General *****
set autoread        " reloads the file automatically when changed
au CursorHold,CursorHoldI * checktime " triggers autoread when cursor stops

" ***** Indentation *****
" TODO: Indentation by file type or maybe vim project??
set tabstop=2	    	" number of visual spaces per TAB
set softtabstop=2 	" number of spaces in tab when editing
set expandtab   		" turns tabs into number of spaces
set shiftwidth=2    " sets the space on autoindents
set autoindent      " copies indentation from previous line
set smartindent     " built in indentation correction

" ***** Line Numbers *****
set number          " show line numbers
set cursorline      " highline line number of current line
set scrolloff=5     " sets the context lines above and below the cursor

" ***** Highlighting *****
set showmatch       " matches []{}()
" sets the paren/bracket/brace matches to a red underline
highlight MatchParen cterm=underline ctermbg=none ctermfg=red

" ***** Error Bells (Sounds and Visual) *****
set noerrorbells    " turns off the error bell sounds
set visualbell t_vb=  " turns of visual bells as well which in some terminals is
                      " set to trigger error bell sounds

" ***** Search *****
set ignorecase      " ignores case when searching
set smartcase       " restores case if capital letter is used in search pattern
set incsearch       " search as characters are entered
set hlsearch        " highlights matches
" removes highlighted matches with leader nh
nnoremap <silent> <leader>ns :nohlsearch<CR>

" ***** History *****
set nobackup        " no backup files
set nowritebackup   " only in case you don't want a backup file while editing
" TODO: instead of no backups, make use of a temp directory
set noswapfile      " no swap files
set undofile        " creates an undo file
set undodir=~/.vim/undodir   " directory for undo files

" ***** Sizing *****
noremap <silent> <leader>= :vertical resize +5<cr>
noremap <silent> <leader>- :vertical resize -5<cr>

" ***** Word Handling *****
" makes daw and ciw accept dash separated words as one word
set iskeyword+=-

" ***** Spell Check *****
set spell
set spelllang=en

" ***** Keyboard Mappings *****
" Moving Between Windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" Toggle Word Wrap
noremap <silent> <leader>w :set wrap!<cr>

" Plug
call plug#begin(stdpath('data') . '/vim-plug')
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
"Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
Plug 'junegunn/fzf', {'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"Plugin for fzf/rg integration
"Plug 'nvim-lua/popup.nvim'
"Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-telescope/telescope.nvim'
"Plug 'airblade/vim-rooter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'raimondi/delimitmate'
Plug 'lilydjwg/colorizer'
Plug 'morhetz/gruvbox'
Plug 'luochen1990/rainbow'
"Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries'}
"Plugin for vim testify
"Plugin for terraform/hcl
call plug#end()

set background=dark
colorscheme gruvbox

source $HOME/.config/nvim/config-plug/startify.vim
source $HOME/.config/nvim/config-plug/fugitive.vim
source $HOME/.config/nvim/config-plug/nerdtree.vim
"source $HOME/.config/nvim/config-plug/rnvimr.vim
"source $HOME/.config/nvim/config-plug/telescope.vim
source $HOME/.config/nvim/config-plug/fzf.vim
source $HOME/.config/nvim/config-plug/coc.vim
source $HOME/.config/nvim/config-plug/airline.vim
" nvim-colorizer - lua
source $HOME/.config/nvim/config-plug/gruvbox.vim
source $HOME/.config/nvim/config-plug/rainbow.vim
"source $HOME/.config/nvim/config-plug/vim-go.vim


nmap <leader>gs :G<CR>
nmap <leader>dh :diffget //2<CR>
nmap <leader>dl :diffget //3<CR>

nmap <leader>st :Startify<CR>

map <C-f> :Files<CR>
map <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :Marks<CR>

set splitbelow
set splitright

set mouse=a

" Copy to clipboard
vnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
nnoremap <leader>y "+y
nnoremap <leader>yy "+yy

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
