" Airline key bindings

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>z <Plug>AirlineSelectPrevTab
nmap <leader>x <Plug>AirlineSelectNextTab

" Airline settings
set encoding=utf-8
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#ale_enabled = 1
let g:airline#extensions#gutentags#enabled = 1
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
set laststatus=2

