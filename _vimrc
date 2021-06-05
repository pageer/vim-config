if &shell == 'powershell'
    " Use cmd.exe rather than Powershell so that all the plugins will work.
    set shell=C:\WINDOWS\system32\cmd.exe
    set shellcmdflag=/c
    set shellquote=
    set shellxquote=(
endif

" Set the runtime path - defaults to vimfiles on Windows.
set rtp+=~/.vim

" Per docs, must be set before ALE is loaded.
let g:ale_completion_enabled = 0
let g:ale_set_balloons = 1

" Plug plugins - need plug.vim installed in ~/.vim/autoload/ ---{{{
call plug#begin('~/.vim/plugged')

    " Utility plugins
    Plug 'tpope/vim-dispatch'
    "Plug 'skywind3000/asyncrun.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " Syntax highlighting and language support
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'aklt/plantuml-syntax'
    Plug 'StanAngeloff/php.vim'
    Plug 'pprovost/vim-ps1'

    " Editing plugins
    Plug 'justinmk/vim-sneak'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    "Plug 'sjl/gundo.vim'
    Plug 'Chiel92/vim-autoformat'
    Plug 'mattn/emmet-vim'

    " Project management plugins
    Plug 'scrooloose/nerdtree'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'joonty/vim-sauce'
    " Load on demand because this slows down startup.
    Plug 'majutsushi/tagbar', { 'on': 'TagbarOpenAutoClose' }

    " Functionality plugins
    Plug 'tpope/vim-fugitive'
    Plug 'mhinz/vim-signify'
    Plug 'mileszs/ack.vim'
    Plug 'janko-m/vim-test'
    Plug 'w0rp/ale'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'jlanzarotta/bufexplorer'
    Plug 'moll/vim-bbye'
    Plug 'tobyS/vmustache'
    Plug 'tobyS/pdv'

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

let g:gruvbox_contrast_dark = 'hard'

" Set the color scheme if we have the proper support.
if has("gui_running")
    "color distinguished
    colorscheme gruvbox
    set cursorline
elseif &t_Co == 256
    "color distinguished
    colorscheme gruvbox
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

" Custom tagbar toggle that also focuses the tagbar.
" Need the exec to load the plugin on demand, because it slows things down.
command! -nargs=0 TagbarFocusToggle if exists('*tagbar#ToggleWindow') | call tagbar#ToggleWindow('f') | else | execute ":TagbarOpenAutoClose"| endif
nnoremap <leader>tt :TagbarFocusToggle<CR>

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

menu .1 &Utility.Toggle\ BufExplorer :ToggleBufExplorer<CR>
menu .2 &Utility.Toggle\ NERDTree :NERDTreeToggle<CR>
menu .3 &Utility.Fix\ Trailing\ Space :FixTrailingSpace<CR>

augroup FileExtensions
    autocmd!
    autocmd BufNewFile,BufRead *.html.twig set syntax=htmldjango
augroup END

" Ack settings
" Let Ack searches happen in the background without blocking the UI.
let g:ack_use_dispatch = 1
let g:ack_default_options = '--ignore tags'
if executable('ag')
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

" Gutentags settings
let g:gutentags_ctags_exclude = [
    \ '*.css', '*.json', '*.xml',
    \ '*.phar', '*.ini', '*.rst', '*.md',
    \ '*vendor*']

" ALE settings
let g:ale_sign_column_always = 1
"if has("win32")
"    let g:ale_php_langserver_executable = 'C:/Users/pgeer/AppData/Roaming/Composer/vendor/felixfbecker/language-server/bin/php-language-server.php'
"    let g:ale_php_psalm_executable = 'C:/Users/pgeer/AppData/Roaming/Composer/vendor/vimeo/psalm/psalm-language-server'
"else
"    let g:ale_php_langserver_executable = '~/.composer/vendor/felixfbecker/language-server/bin/php-language-server.php'
"endif
"let g:ale_php_langserver_use_global = 1
"set omnifunc=ale#completion#OmniFunc
"let g:ale_linters = { 'php': ['langserver'] }
"let g:ale_linters_explicit = 1
"let g:ale_php_phpcs_standard = 'PSR2'
"let g:ale_php_phpcs_executable = 'phpcs'
"let g:ale_php_phpcs_use_global = 1

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
let g:airline_section_z='%p%% %#__accent_bold#%{g:airline_symbols.linenr}%l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__#:%v %{strftime("%b %d %I:%M:%S%p")}'
let status_update_timer = timer_start(1000, 'UpdateStatusBar',{'repeat':-1})
function! UpdateStatusBar(timer)
  execute 'let &ro = &ro'
endfunction

" CTags management
" Set the tags file - look in current directory, the cpoptions uses CWD.
set tags=./tags,~/.vimtags
set cpoptions+=d

" Remove trailing spaces from file.
command! -nargs=0 FixTrailingSpace call execute("normal! mp:%s/\\s\\+$//e\<cr>`p")

" phpunit settings
"let g:phpunit_tmpfile = expand("~/AppData/Local/Temp/vim_phpunit.out")

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
nnoremap <leader>a :cprevious
nnoremap <leader>s :cnext

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
