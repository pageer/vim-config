if &shell == 'powershell'
    " Use cmd.exe rather than Powershell so that all the plugins will work.
    set shell=C:\WINDOWS\system32\cmd.exe
    set shellcmdflag=/c
    set shellquote=
    set shellxquote=(
endif

" Set the runtime path - defaults to vimfiles on Windows.
set rtp+=~/.vim

" Plug plugins - need plug.vim installed in ~/.vim/autoload/ ---{{{
call plug#begin('~/.vim/plugged')

    " Utility plugins
    Plug 'tpope/vim-dispatch'
    Plug 'skywind3000/asyncrun.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " Syntax highlighting and language support
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " TypeScript syntax
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'aklt/plantuml-syntax'
    Plug 'StanAngeloff/php.vim'
    Plug 'pprovost/vim-ps1'
    Plug 'fatih/vim-go'
    Plug 'pangloss/vim-javascript'

    " Editing plugins
    Plug 'justinmk/vim-sneak'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    "Plug 'sjl/gundo.vim'
    Plug 'Chiel92/vim-autoformat'

    " Project management plugins
    Plug 'scrooloose/nerdtree'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'joonty/vim-sauce'
    Plug 'liuchengxu/vista.vim'
    " Load on demand because this slows down startup.
    Plug 'majutsushi/tagbar', { 'on': 'TagbarOpenAutoClose' }

    " Functionality plugins
    Plug 'tpope/vim-fugitive'
    Plug 'mhinz/vim-signify'
    Plug 'pageer/ack.vim'
    Plug 'janko-m/vim-test'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'jlanzarotta/bufexplorer'
    " Better buffer deletion
    Plug 'moll/vim-bbye'
    Plug 'tobyS/vmustache'
    Plug 'pageer/pdv'

    " Themes
    "Plug 'ayu-theme/ayu-vim'
    "Plug 'drewtempelmeyer/palenight.vim'
    Plug 'morhetz/gruvbox'

call plug#end()
" ---}}}

" Consolidate directories for swap, backup, etc.  Stolen from SPF13 ---{{{
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    let common_dir = parent . '/.' . prefix

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            execute "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()
" End directory consolidation ---}}}

" Start my actual customizations

let g:sauce_path = expand("~/.vim/vimsauce/")

" Make indentaiton 4 spaces
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

set fileformats=unix,dos

set backspace=indent,eol,start
set hlsearch
set incsearch
set nofoldenable
set number
set signcolumn=yes
set visualbell
syntax on

set grepprg=grep

set guioptions-=t
set guioptions-=T
set guifont=Hack\ Nerd\ Font\ Mono:h10,Hack:h10

let g:gruvbox_contrast_dark = 'hard'

"let g:go_def_mode='gopls'
"let g:go_info_mode='gopls'

" Set the color scheme if we have the proper support.
if has("gui_running")
    colorscheme gruvbox
    set cursorline
elseif &t_Co == 256
    if &shell == 'powershell'
        colorscheme gruvbox
    endif 
endif

" Key bindings
let mapleader = ","
let maplocalleader = ","

" Easier escaping
inoremap jk <Esc>

" Less annoying buffer swapping
inoremap <C-Tab> <C-^>
nnoremap <C-Tab> <C-^>

" Move between windows with just ctrl+movement
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

nnoremap <leader>e :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']
"nmap <leader>nt :NERDTreeFind<CR>

" Customizations for Vista outline viewer
let g:vista_icon_indent = ["▸ ", ""]
let g:vista#renderer#enable_icon = 1

" Custom tagbar toggle that also focuses the tagbar.
" Need the exec to load the plugin on demand, because it slows things down.
command! -nargs=0 TagbarFocusToggle if exists('*tagbar#ToggleWindow') | call tagbar#ToggleWindow('f') | else | execute ":TagbarOpenAutoClose"| endif
nnoremap <leader>tt :TagbarFocusToggle<CR>

" Shortcuts for Vista code browser
nnoremap <leader>v :Vista!!<CR>

" Shortcut to list current buffers.
nnoremap <leader>b :ls<CR>
nnoremap <leader>d :Bdelete<CR>

" Turn off highlighting when we hit escape.
" This can cause weirdness when running in certain terminals under Linux.
if has("win32")
    nnoremap <esc> :nohlsearch<return><esc>
endif

" Toggle relative line numbers
nnoremap <leader>r :set rnu!<CR>

menu .1 &Utility.BufExplorer :ToggleBufExplorer<CR>
menu .2 &Utility.NERDTree :NERDTreeToggle<CR>
menu .3 &Utility.Tagbar :TagbarFocusToggle<CR>
menu .4 &Utility.Fix\ Trailing\ Space :FixTrailingSpace<CR>

augroup FileExtensions
    autocmd!
    autocmd BufNewFile,BufRead *.html.twig set syntax=htmldjango
augroup END

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

" CtrlP settings
" let g:ctrlp_custom_ignore = {
"   \ 'dir':  '\v[\/]\.(git|hg|svn)$',
"   \ 'file': '\v\.(exe|so|dll)$',
"   \ 'link': 'some_bad_symbolic_links',
"   \ }

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

" CoC settings
let g:coc_config_home = expand("~/.vim")
let g:coc_global_extensions = ['coc-html', 'coc-tsserver', 'coc-pyright', 'coc-powershell', 'coc-phpls', 'coc-go']

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) : 
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Select current item on pressing enter
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> K :call CocActionAsync('doHover')<CR>
nnoremap <silent><nowait> <leader>s :CocList -I symbols<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>rf <Plug>(coc-refactor)

"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  elseif (coc#rpc#ready())
"    call CocActionAsync('doHover')
"  else
"    execute '!' . &keywordprg . " " . expand('<cword>')
"  endif
"endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

if has("gui_running")
    menu .1 &CoC.List\ Diagnostics :CocList diagnostics<CR>
    menu .2 &CoC.Outline :CocList outline<CR>
    menu .3 &CoC.Commands :CocList commands<CR>
    menu .4 &CoC.Extensions :CocList extensions<CR>
endif

" Airline settings
set encoding=utf-8
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale_enabled = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#gutentags#enabled = 1
set laststatus=2

let g:airline#extensions#tabline#buffer_idx_mode = 1
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

" Put the current date and time in the status line and keep it updated
"let g:airline_section_z='%p%% %#__accent_bold#%{g:airline_symbols.linenr}%l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__#:%v %{strftime("%b %d %I:%M:%S%p")}'
"let status_update_timer = timer_start(1000, 'UpdateStatusBar',{'repeat':-1})
"function! UpdateStatusBar(timer)
"  execute 'let &ro = &ro'
"endfunction

" CTags management
" Set the tags file - look in current directory, the cpoptions uses CWD.
set tags=./tags,~/.vimtags
set cpoptions+=d

" Remove trailing spaces from file.
command! -nargs=0 FixTrailingSpace call execute("normal! mp:%s/\\s\\+$//e\<cr>`p")

" phpunit settings
"let g:phpunit_tmpfile = expand("~/AppData/Local/Temp/vim_phpunit.out")

" Prompt for jump to location.
function! GotoJump()
  jumps
  let j = input("Please select your jump: ")
  if j != ''
    let pattern = '\v\c^\+'
    if j =~ pattern
      let j = substitute(j, pattern, '', 'g')
      execute "normal " . j . "\<c-i>"
    else
      execute "normal " . j . "\<c-o>"
    endif
  endif
endfunction
nmap <leader>j :call GotoJump()<CR>

" toggles the quickfix window. ---{{{
let g:jah_Quickfix_Win_Height = 10
let g:jah_Loclist_Win_Height = 10

command! -bang -nargs=? QFix call QFixToggle()
function! QFixToggle()
    let nr = winnr("$")
    cwindow "g:jah_Quickfix_Win_Height"
    let nr2 = winnr("$")
    if nr == nr2
        cclose
    endif
endfunction

command! -bang -nargs=? LocList call LocListToggle()
function! LocListToggle()
    let nr = winnr("$")
    lwindow "g:jah_Loclist_Win_Height"
    let nr2 = winnr("$")
    if nr == nr2
        lclose
    endif
endfunction

" vim-test settings
let g:test#runner_commands = ['PHPUnit', 'Nose']

" Settings from Learn VimScript the Hard Way -----{{{

function! FoldColumnToggle()
    if &foldcolumn
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=4
    endif
endfunction

let g:quickfix_is_open = 0
function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction

nnoremap <leader>q :call QFixToggle()<cr>
nnoremap <leader>f :call FoldColumnToggle()<cr>

iabbrev funciton function
iabbrev functino function

iabbrev jasit it("", function() {<CR><CR>}
iabbrev jasdesc describe("", function() {<CR><CR>}

nnoremap <leader>ve :vsplit $MYVIMRC<CR>
nnoremap <leader>vs :source $MYVIMRC<CR>

nnoremap <leader>pb :belowright vsplit bufname("#")<CR>
nnoremap <leader>w :match Error /\v +$/<CR>
nnoremap <leader>W :match none<CR>
nnoremap / /\v
"nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>
"nnoremap <leader>a :cprevious
"nnoremap <leader>s :cnext

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
