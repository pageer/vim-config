if has("win32") || has("win32_gui")
    let s:use_powershell = 0
    if s:use_powershell
        set shell=powershell
        set shellcmdflag=\ -Command
        set shellquote=\"
        set shellxquote= 
    else
        " Use cmd.exe rather than Powershell so that all the plugins will work.
        set shell=C:\WINDOWS\system32\cmd.exe
        set shellcmdflag=/c
        set shellquote= 
        set shellxquote=(
    endif
endif

" Set the runtime path - defaults to vimfiles on Windows.
set rtp+=~/.vim

" Plug plugins - need plug.vim installed in ~/.vim/autoload/ ---{{{
call plug#begin('~\.vim\plugged')

Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'Chiel92/vim-autoformat'
Plug 'mileszs/ack.vim'
Plug 'joonty/vim-sauce'
Plug 'janko-m/vim-test'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug 'skywind3000/asyncrun.vim'
Plug 'sjl/gundo.vim'
"Plug 'yuttie/comfortable-motion.vim'
" Load on demand because this slows down startup.
Plug 'majutsushi/tagbar', { 'on': 'TagbarOpenAutoClose' }

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

" Make indentaiton 4 spaces
set tabstop=4 
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

set backspace=indent,eol,start
set hlsearch
set incsearch
set nofoldenable
set number
set visualbell
syntax on

set grepprg=grep

set guioptions-=t
set guioptions-=T
set guifont=Hack:h10

" Set the color scheme if we have the proper support.
if has("gui_running")
    color distinguished
    set cursorline
elseif &t_Co == 256
    color distinguished
endif

" Key bindings
let mapleader = ","
let maplocalleader = ","

" Easier escaping
inoremap jk <Esc>

" Move between windows with just ctrl+movement
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

" Comfortable motion configuration
if exists("*comfortable_motion#flick")
    let g:comfortable_motion_no_default_key_mappings = 1
    let g:comfortable_motion_impulse_multiplier = 1  " Feel free to increase/decrease this value.
    let g:comfortable_motion_scroll_down_key = "j"
    let g:comfortable_motion_scroll_up_key = "k"
    nnoremap <silent> <C-d> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
    nnoremap <silent> <C-u> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
    nnoremap <silent> <C-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
    nnoremap <silent> <C-b> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>
endif

"map <C-e> <plug>NERDTreeToggle<CR>

nnoremap <leader>e :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']
"nmap <leader>nt :NERDTreeFind<CR>

" Custom tagbar toggle that also focuses the tagbar.
" Need the exec to load the plugin on demand, because it slows things down.
command! -nargs=0 TagbarFocusToggle if exists('*tagbar#ToggleWindow') | call tagbar#ToggleWindow('f') | else | execute ":TagbarOpenAutoClose"| endif
nnoremap <leader>tt :TagbarFocusToggle<CR>

" Shortcut to list cirrent buffers.
nnoremap <leader>b :ls<CR>

" Turn off highlighting when we hit escape.
nnoremap <esc> :nohlsearch<return><esc>

" Toggle relative line numbers
nnoremap <leader>r :set rnu!<CR>

augroup FileExtensions
    autocmd!
    autocmd BufNewFile,BufRead *.html.twig set syntax=htmldjango
augroup END

" CtrlP settings
" let g:ctrlp_custom_ignore = {
"   \ 'dir':  '\v[\/]\.(git|hg|svn)$',
"   \ 'file': '\v\.(exe|so|dll)$',
"   \ 'link': 'some_bad_symbolic_links',
"   \ }

" ALE settings
"let g:ale_linters = { 'php': ['phpcs'] }
"let g:ale_php_phpcs_standard = 'PSR2'
"let g:ale_php_phpcs_standard = 'DattoCoreProducts'
"let g:ale_php_phpcs_executable = 'phpcs'
"let g:ale_php_phpcs_use_global = 1

" Airline settings
set encoding=utf-8
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale_enabled = 1
let g:airline_skip_empty_sections = 1
set laststatus=2

" Add status of AsyncRun tasks to Airline status bar.
"let g:asyncrun_status = 'stopped'
"let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
"augroup QuickfixStatus
"    autocmd! BufWinEnter quickfix setlocal 
"        \ statusline=%t\ [%{g:asyncrun_status}]\ %{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}\ %=%-15(%l,%c%V%)\ %P
"augroup END

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

" CTags management
" Set the tags file - look in current directory, the cpoptions uses CWD rather
" than bugger dir.
set tags=./tags,~/.vimtags
set cpoptions+=d
" Function to do tag update using AsyncRun plugin.
function! UpdateTags()
    if exists('g:auto_update_tags') && exists('*asyncrun#get_root')
        if !exists('g:auto_update_tags_flags')
            g:auto_update_tags_flags = ''
        endif
        silent execute "AsyncRun -cwd=<root> ctags -R " . g:auto_update_tags_flags . " " . asyncrun#get_root('%')
    else
        "echom "Tag auto-update disabled"
    endif
endfunction
command! -nargs=0 UpdateTags call UpdateTags()
augroup tag_update
    autocmd!
    autocmd BufWritePost * :UpdateTags
augroup END

command! -nargs=0 FixTrailingSpace call execute("normal! mp:%s/\\s\\+$//e\<cr>`p")

" phpunit settings
"let g:phpunit_tmpfile = expand("~/AppData/Local/Temp/vim_phpunit.out")

" toggles the quickfix window. ---{{{
let g:jah_Quickfix_Win_Height = 10

command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
  else
    execute "copen " . g:jah_Quickfix_Win_Height
  endif
endfunction

" used to track the quickfix window
augroup QFixToggle
 autocmd!
 autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
 autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END

nnoremap <leader>q :QFix<CR>
"--------}}}

" vim-test settings
let g:test#runner_commands = ['PHPUnit', 'Nose']

" Settings from Learn VimScript the Hard Way -----{{{

" Move line down in file
"nnoremap - ddp
" Move line up in file
"nnoremap _ ddkP

" Upercase the current word
"inoremap <C-U> <ESC>viwUi
"nnoremap <C-U> viwU
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

nnoremap <leader>f :call FoldColumnToggle()<cr>

iabbrev funciton function
iabbrev functino function

iabbrev jasit it("", function() {<CR><CR>}
iabbrev jasdesc describe("", function() {<CR><CR>}

nnoremap <leader>ve :vsplit $MYVIMRC<CR>
nnoremap <leader>vs :source $MYVIMRC<CR>

nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>`>ll

nnoremap <leader>pb :belowright vsplit bufname("#")<CR>
nnoremap <leader>w :match Error /\v +$/<CR>
nnoremap <leader>W :match none<CR>
nnoremap / /\v
"nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>
nnoremap <leader>a :cprevious
nnoremap <leader>s :cnext

" Replace inner/outer paren/brace content.
onoremap in( :<c-u>normal! f(v%<cr>
onoremap il( :<c-u>normal! F)v%<cr>
onoremap on( :<c-u>normal! f(v%<cr>
onoremap ol( :<c-u>normal! F)v%<cr>
onoremap in{ :<c-u>normal! f{vi}<cr>
onoremap il{ :<c-u>normal! F}vi{<cr>
onoremap on{ :<c-u>normal! f{vo}h<cr>
onoremap ol{ :<c-u>normal! F}v%<cr>

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
