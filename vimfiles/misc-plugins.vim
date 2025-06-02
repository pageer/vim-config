" Miscellaneous plugins configuration
" This is for plugins without enough config to bother with another file.

nnoremap <leader>d :Bdelete<CR>

" Ack settings
" Let Ack searches happen in the background without blocking the UI.
let g:ack_use_dispatch = 0
let g:ack_default_options = '--ignore tags'
if executable('rg')
    let g:ackprg = 'rg --vimgrep'
elseif executable('ag')
    let g:ackprg = 'ag --vimgrep --ignore tags'
endif

" Dispatch settings
" The job support on Windows seem to be broken ATM.
let g:dispatch_no_job_make = 1

" pdv settings
let g:pdv_template_dir = expand("~/.vim/plugged/pdv/templates")
command! -nargs=0 Phpdoc call pdv#DocumentCurrentLine()
nnoremap <C-Return> :call pdv#DocumentCurrentLine()<cr>

" vim-go settings
let g:go_doc_popup_window = 1

" Gutentags settings
let g:gutentags_ctags_exclude = [
    \ '*.css', '*.json', '*.xml',
    \ '*.phar', '*.ini', '*.rst', '*.md',
    \ '*vendor*']

" End Plugin Config ---}}}

" Menus ---{{{

menu .1 &Utility.BufExplorer :ToggleBufExplorer<CR>
menu .2 &Utility.NERDTree :NERDTreeToggle<CR>
menu .3 &Utility.Tagbar :TagbarFocusToggle<CR>
menu .4 &Utility.Fix\ Trailing\ Space :FixTrailingSpace<CR>

" Menus --}}}-
