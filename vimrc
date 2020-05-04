" enable syntax processing
if !exists("g:syntax_on")
    syntax enable
endif

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
set relativenumber  " show line number relative to current line
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
nnoremap <silent> <leader>nh :nohlsearch<CR>

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

" ***** Plug Plugin Manager *****
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf' ", { 'do': { -> fzf#install() } }
Plug 'ycm-core/YouCompleteMe'
Plug 'mxw/vim-jsx'
Plug 'StanAngeloff/php.vim'
Plug 'vim-utils/vim-man'
call plug#end()

" ***** Theme Options *****
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
nmap <silent> <leader><space> :NERDTreeToggle<cr>     

" ***** UndoTree Options *****
nmap <silent> <leader>u :UndotreeToggle<cr>

" ***** YouCompleteMe Options *****
noremap <silent> <leader>gd :YcmCompleter GoTo<cr>
noremap <silent> <leader>gf :YcmCompleter FixIt<cr>

" ***** Powerline Plugin *****
set rtp+=~/.local/lib/python3.7/site-packages/powerline/bindings/vim/
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

" ***** PHP Setup *****
au BufWritePost *.php silent! !eval '[ -f ".git/hooks/ctags" ] && .git/hooks/ctags' &

