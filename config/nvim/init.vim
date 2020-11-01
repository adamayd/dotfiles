" ****** Inspiration @ https://github.com/ChristianChiarulli/nvim ******
" 
" Plug
call plug#begin(stdpath('data') . '/vim-plug')
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
Plug 'morhetz/gruvbox'
call plug#end()

colorscheme gruvbox
set background=dark

source $HOME/.config/nvim/config-plug/startify.vim
source $HOME/.config/nvim/config-plug/fugitive.vim
source $HOME/.config/nvim/config-plug/rnvimr.vim
" - Uberzug?
" fzf
" CoC
" nvim-colorizer - lua
" airline instead of ligthline or powerline??
" vim-go


nmap <leader>gs :G<CR>
nmap <leader>dh :diffget //2<CR>
nmap <leader>dl :diffget //3<CR>

nmap <leader><space> :RnvimrToggle<CR>
