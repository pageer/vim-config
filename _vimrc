" So t the runtime path - defaults to vimfiles on Windows.
set rtp+=~/.vim

" Load all our plugins first
source ~/.vim/plugin-loading.vim

" Include the base config
source ~/.vim/base-config.vim

" Build on the base config with my customizations
source ~/.vim/sauce-config.vim
source ~/.vim/coc-config.vim
source ~/.vim/nerdtree-config.vim
source ~/.vim/tagbar-config.vim
source ~/.vim/airline-config.vim
source ~/.vim/vimtest-config.vim
source ~/.vim/misc-plugins.vim
source ~/.vim/lvsthw.vim

" Put the current date and time in the status line and keep it updated
"let g:airline_section_z='%p%% %#__accent_bold#%{g:airline_symbols.linenr}%l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__#:%v %{strftime("%b %d %I:%M:%S%p")}'
"let status_update_timer = timer_start(1000, 'UpdateStatusBar',{'repeat':-1})
