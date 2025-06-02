" Vim-Test settings

" Key bindings
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>tn :TestNearest<CR>
nnoremap <leader>ts :TestSuite<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tv :TestVisit<CR>

" vim-test settings
let g:test#runner_commands = ['PHPUnit', 'Nose']
let test#strategy = 'vimterminal'
if has('win32')
    " Windows cmd.exe doesn't like ./vendor/bin/
    let test#php#phpunit#executable = 'vendor\bin\phpunit.bat'
endif

