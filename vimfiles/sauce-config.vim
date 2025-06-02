
let g:sauce_path = expand("~/.vim/vimsauce/")

function! SauceList()
    let file_list = split(glob(g:sauce_path . '/*')) 
    for file_path in file_list
        echo fnamemodify(file_path, ':t:r')
    endfor
endfunction

" Since vim-sauce doesn't have a 'list' command...
command! -nargs=0 SauceList call SauceList()

