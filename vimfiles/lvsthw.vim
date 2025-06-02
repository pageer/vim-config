" Settings from Learn VimScript the Hard Way -----{{{

iabbrev funciton function
iabbrev functino function

iabbrev jasit it("", function() {<CR><CR>}
iabbrev jasdesc describe("", function() {<CR><CR>}

augroup filetype_shortcuts
    autocmd!
    autocmd FileType javascript,php nnoremap <buffer> <localleader>c I//<esc>
    autocmd FileType python :nnoremap <buffer> <localleader>c I#<esc>
    autocmd FileType sql,ada :nnoremap <buffer> <localleader>c I--<esc>
    autocmd FileType php,javascript :iabbrev <buffer> iif if ()<left>
    autocmd FileType python :iabbrev <buffer> iif if:<left>
augroup END

augroup markdown_shortcuts
    autocmd!
    autocmd FileType markdown onoremap ih :<c-u>execute "normal! ?^==\\+$\\\|^--\\+$\r:nohlsearch\rkvg_"<cr>
    autocmd FileType markdown onoremap ah :<c-u>execute "normal! ?^==\\+$\\\|^--\\+$\r:nohlsearch\rg_vk0"<cr>
augroup END

" End LVSTHW code -----}}}
