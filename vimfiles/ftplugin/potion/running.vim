if !exists("g:potion_command")
    let g:potion_command = "/mnt/c/Users/pgeer/ownCloud/potion/bin/potion"
endif

nnoremap <buffer> <localleader>r :call potion#running#PotionCompileAndRunFile()<cr>
nnoremap <buffer> <localleader>b :call potion#running#PotionShowBytecode()<cr>
