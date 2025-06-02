" Tagbar settings

" TagBar toggling
nnoremap <leader>tt :TagbarFocusToggle<CR>

" Custom tagbar toggle that also focuses the tagbar.
" Need the exec to load the plugin on demand, because it slows things down.
command! -nargs=0 TagbarFocusToggle if exists('*tagbar#ToggleWindow') | call tagbar#ToggleWindow('f') | else | execute ":TagbarOpenAutoClose"| endif

