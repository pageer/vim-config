" Base configuration for sharable by all verisons

" Custom Functions ---{{{
"
" Consolidate directories for swap, backup, etc.  Stolen from SPF13.
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
nnoremap <leader>j :call GotoJump()<CR>

function! QFixToggle()
    let nr = winnr("$")
    cwindow "g:jah_Quickfix_Win_Height"
    let nr2 = winnr("$")
    if nr == nr2
        cclose
    endif
endfunction

function! LocListToggle()
    let nr = winnr("$")
    lwindow "g:jah_Loclist_Win_Height"
    let nr2 = winnr("$")
    if nr == nr2
        lclose
    endif
endfunction

function! FoldColumnToggle()
    if &foldcolumn
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=4
    endif
endfunction

" NOTE: This is not used
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

" Custom Functions ---}}}

" Initialization ---{{{

" Set up custom directory locations
call InitializeDirectories()

" Setup for custom list toggling functions
let g:quickfix_is_open = 0
let g:jah_Quickfix_Win_Height = 10
let g:jah_Loclist_Win_Height = 10
command! -bang -nargs=? LocList call LocListToggle()
command! -bang -nargs=? QFix call QFixToggle()

" Remove trailing spaces from file.
command! -nargs=0 FixTrailingSpace call execute("normal! mp:%s/\\s\\+$//e\<cr>`p")

if has("win32")
    command! -nargs=0 Term call execute("belowright terminal ++close powershell")
else
    command! -nargs=0 Term call execute("belowright terminal ++close")
endif

" Initialization ---}}}

" Basic Formatting and Behavior Settings ---{{{

" Make indentaiton 4 spaces
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

set fileformats=unix,dos

" Allows you to maintain undo history when switching buffers
set hidden

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

if has('win32')
    set guifont=Hack\ NFM:h11 ",Hack\ Nerd\ Font\ Mono:h10,Hack:h11,Hack\ Nerd\ Font\ 12,Ubuntu\ Mono\ 12
else
    set guifont=Hack\ Nerd\ Font\ 12,Ubuntu\ Mono\ 12
endif

let g:gruvbox_contrast_dark = 'hard'
set bg=dark

" Set the color scheme if we have the proper support.
if has("gui_running")
    colorscheme gruvbox
    set cursorline
elseif &t_Co == 256
    colorscheme gruvbox
endif

if has("nvim")
    set termguicolors
    hi statusline gui=NONE
endif

" CTags management
" Set the tags file - look in current directory, the cpoptions uses CWD.
set tags=./tags,~/.vimtags
set cpoptions+=d

" Basic Formatting and Behavior Settings ---}}}

" Key Bindings ---{{{

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

" Shortcut to list current buffers.
nnoremap <leader>b :ls<CR>

" Turn off highlighting when we hit escape.
" This can cause weirdness when running in certain terminals under Linux.
if has("win32")
    nnoremap <esc> :nohlsearch<return><esc>
endif

" Toggle relative line numbers
nnoremap <leader>r :set rnu!<CR>

nnoremap <leader>qq :call QFixToggle()<cr>
nnoremap <leader>f :call FoldColumnToggle()<cr>

nnoremap <leader>ve :vsplit $MYVIMRC<CR>
nnoremap <leader>vs :source $MYVIMRC<CR>

nnoremap <leader>pb :belowright vsplit bufname("#")<CR>
nnoremap <leader>w :match Error /\v +$/<CR>
nnoremap <leader>W :match none<CR>
nnoremap / /\v

" Key Bindings ---}}}

" Misc settings ---{{{

" Make Twig templates use Django syntax
augroup FileExtensions
    autocmd!
    autocmd BufNewFile,BufRead *.html.twig set syntax=htmldjango
augroup END

" Misc settings ---}}}
