" NERDTree configuration

" Starts with NERDTree open if no file is passed on command line
"function! StartUp()
"  if 0 == argc()
"    NERDTree
"  end
"endfunction
"autocmd VimEnter * call StartUp()
let NERDTreeQuitOnOpen=1  " closes NERDTree when file is opened
let NERDTreeShowHidden=1  " shows hidden files by default
" shortcut to run NERDTree
nmap <silent> <leader><space> :NERDTreeToggle<cr>     
