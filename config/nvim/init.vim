" ****** Inspiration @ https://github.com/ChristianChiarulli/nvim ******
" 
" Plug
call plug#begin(stdpath('data') . '/vim-plug')
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
Plug 'junegunn/fzf', {'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'lilydjwg/colorizer'
Plug 'morhetz/gruvbox'
Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries'}
call plug#end()

colorscheme gruvbox
set background=dark

source $HOME/.config/nvim/config-plug/startify.vim
source $HOME/.config/nvim/config-plug/fugitive.vim
source $HOME/.config/nvim/config-plug/rnvimr.vim
source $HOME/.config/nvim/config-plug/fzf.vim
source $HOME/.config/nvim/config-plug/coc.vim
source $HOME/.config/nvim/config-plug/airline.vim
" nvim-colorizer - lua
source $HOME/.config/nvim/config-plug/vim-go.vim


nmap <leader>gs :G<CR>
nmap <leader>dh :diffget //2<CR>
nmap <leader>dl :diffget //3<CR>

nmap <leader><space> :RnvimrToggle<CR>

map <C-f> :Files<CR>
map <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :Marks<CR>

