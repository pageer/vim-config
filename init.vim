" NeoVim inti file - just wraps _vimrc
set runtimepath^=~/.vim
let &packpath = &runtimepath
if exists('g:vscode')
    source ~/.vim/vscode-config.vim
else
    if filereadable(expand("~/_vimrc"))
      source ~/_vimrc
    elseif filereadable(expand("~/.vimrc"))
      source ~/.vimrc
    endif

    source ~/.vim/nvim-config.vim
endif
