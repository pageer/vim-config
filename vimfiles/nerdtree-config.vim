" Settings for NERDTree

" NERDTree toggling
nnoremap <leader>e :NERDTreeToggle<CR>
"nmap <leader>nt :NERDTreeFind<CR>

"NERDTree settings
let NERDTreeIgnore = ['\.pyc$']
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Set arrow icons
let g:NERDTreeDirArrowExpandable = "▸"
let g:NERDTreeDirArrowCollapsible = "▾"
