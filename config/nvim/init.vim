""""" Import settings from Vim """""
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath=&runtimepath
" source ~/.vimrc

"""" Initial Settings """""



""""" Vim-Plug for plugin management """""
call plug#begin('~/nvim/plugged')
Plug 'preservim/nerdtree'
Plug 'bfredl/nvim-miniyank'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'StanAngeloff/php.vim'
Plug 'stephpy/vim-php-cs-fixer'
Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install --no-dev -o'}
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'phpactor/ncm2-phpactor'
call plug#end()

""""" NERDTree Options """""
" Starts with NERDTree open if no file is passed on command line
function! StartUp()
  if 0 == argc()
    NERDTree
  end
endfunction
autocmd VimEnter * call StartUp()

let NERDTreeQuitOnOpen=1  " closes NERDTree when file is opened
" Shortcut to run NERDTree
nmap <leader><space> :NERDTreeToggle<cr>     

""""" Mini Yank keybindings """""
map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)
" "startput" will directly put the most recent item in the shared history:
map <leader>p <Plug>(miniyank-startput)
map <leader>P <Plug>(miniyank-startPut)
" Right after a put, use "cycle" to go through history:
map <leader>n <Plug>(miniyank-cycle)
" Stepped too far? You can cycle back to more recent items using:
map <leader>N <Plug>(miniyank-cycleback)
" Maybe the register type was wrong? Well, you can change it after putting:
map <Leader>c <Plug>(miniyank-tochar)
map <Leader>l <Plug>(miniyank-toline)
map <Leader>b <Plug>(miniyank-toblock)

""""" PHP Code Sniffer Fixer """""
" If php-cs-fixer is in $PATH, you don't need to define line below
" let g:php_cs_fixer_path = "~/php-cs-fixer.phar" " define the path to the php-cs-fixer.phar

" If you use php-cs-fixer version 1.x
let g:php_cs_fixer_level = "symfony"                   " options: --level (default:symfony)
let g:php_cs_fixer_config = "default"                  " options: --config
" If you want to define specific fixers:
"let g:php_cs_fixer_fixers_list = "linefeed,short_tag" " options: --fixers
"let g:php_cs_fixer_config_file = '.php_cs'            " options: --config-file
" End of php-cs-fixer version 1 config params

" If you use php-cs-fixer version 2.x
let g:php_cs_fixer_rules = "@PSR2"          " options: --rules (default:@PSR2)
"let g:php_cs_fixer_cache = ".php_cs.cache" " options: --cache-file
"let g:php_cs_fixer_config_file = '.php_cs' " options: --config
" End of php-cs-fixer version 2 config params

let g:php_cs_fixer_php_path = "php"               " Path to PHP
let g:php_cs_fixer_enable_default_mapping = 1     " Enable the mapping by default (<leader>pcd)
let g:php_cs_fixer_dry_run = 0                    " Call command with dry-run option
let g:php_cs_fixer_verbose = 0                    " Return the output of command if 1, else an inline information.
"nnoremap <silent><leader>pcd :call PhpCsFixerFixDirectory()<CR>
"nnoremap <silent><leader>pcf :call PhpCsFixerFixFile()<CR>
" If you want to add fix on save functionality, add this string to the end of ~/.vimrc:
"autocmd BufWritePost *.php silent! call PhpCsFixerFixFile()

""""" NVim Completion Manager 2 """""
"let g:python3_host_prog=/usr/local/lib/python3.7/site-packages
" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()
" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect


""""" Calls git hook to create tags on save of php files """""
au BufWritePost *.php silent! !eval '[[ -f "$(git rev-parse --git-dir)/hooks/ctags" ]] && $(git rev-parse --git-dir)/hooks/ctags' &
