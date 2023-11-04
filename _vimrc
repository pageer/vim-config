" Set the runtime path - defaults to vimfiles on Windows.
set rtp+=~/.vim

" Plug plugins - need plug.vim installed in ~/.vim/autoload/ ---{{{
call plug#begin('~/.vim/plugged')

    " Utility plugins
    Plug 'tpope/vim-dispatch'
    Plug 'skywind3000/asyncrun.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ryanoasis/vim-devicons'

    " Syntax highlighting and language support
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " TypeScript syntax
    Plug 'HerringtonDarkholme/yats.vim'
    Plug 'aklt/plantuml-syntax'
    Plug 'StanAngeloff/php.vim'
    Plug 'pprovost/vim-ps1'
    Plug 'fatih/vim-go'
    Plug 'pangloss/vim-javascript'
    Plug 'udalov/kotlin-vim'

    " Editing plugins
    Plug 'justinmk/vim-sneak'
    Plug 'easymotion/vim-easymotion'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    "Plug 'sjl/gundo.vim'
    Plug 'Chiel92/vim-autoformat'

    " Project management plugins
    Plug 'scrooloose/nerdtree'
    Plug 'lambdalisue/fern.vim', { 'branch': 'main' }
    if has("lua")
        Plug 'obaland/vfiler.vim'
        Plug 'obaland/vfiler-column-devicons'
    endif
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'joonty/vim-sauce'
    "Plug 'liuchengxu/vista.vim'
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
" End Plug plugins ---}}}


" Custom Functions ---{{{

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

" For use in tab trigger
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! ShowDocumentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  elseif (coc#rpc#ready())
"    call CocActionAsync('doHover')
"  else
"    execute '!' . &keywordprg . " " . expand('<cword>')
"  endif
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

"function! UpdateStatusBar(timer)
"  execute 'let &ro = &ro'
"endfunction

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

function! SauceList()
    let file_list = split(glob(g:sauce_path . '/*')) 
    for file_path in file_list
        echo fnamemodify(file_path, ':t:r')
    endfor
endfunction

" End Custom Functions ---}}}


" Initialization ---{{{

" Set up custom directory locations
call InitializeDirectories()

" Start my actual customizations

let g:sauce_path = expand("~/.vim/vimsauce/")

" Setup for custom list toggling functions
let g:quickfix_is_open = 0
let g:jah_Quickfix_Win_Height = 10
let g:jah_Loclist_Win_Height = 10
command! -bang -nargs=? LocList call LocListToggle()
command! -bang -nargs=? QFix call QFixToggle()

" Put the current date and time in the status line and keep it updated
"let g:airline_section_z='%p%% %#__accent_bold#%{g:airline_symbols.linenr}%l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__#:%v %{strftime("%b %d %I:%M:%S%p")}'
"let status_update_timer = timer_start(1000, 'UpdateStatusBar',{'repeat':-1})

" Remove trailing spaces from file.
command! -nargs=0 FixTrailingSpace call execute("normal! mp:%s/\\s\\+$//e\<cr>`p")

if has("win32")
    command! -nargs=0 Term call execute("belowright terminal ++close powershell")
else
    command! -nargs=0 Term call execute("belowright terminal ++close")
endif

" Since vim-sauce doesn't have a 'list' command...
command! -nargs=0 SauceList call SauceList()

" End Initialization ---}}}


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
    set guifont=Hack\ NFM:h11,Hack\ Nerd\ Font\ Mono:h101Hack:h11,Hack\ Nerd\ Font\ 12,Ubuntu\ Mono\ 12
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

" CTags management
" Set the tags file - look in current directory, the cpoptions uses CWD.
set tags=./tags,~/.vimtags
set cpoptions+=d

" End Basic Formatting and Behavior Settings ---}}}


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

" NERDTree toggling
nnoremap <leader>e :NERDTreeToggle<CR>
"nmap <leader>nt :NERDTreeFind<CR>

" TagBar toggling
nnoremap <leader>tt :TagbarFocusToggle<CR>

" Vim-test running
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>tn :TestNearest<CR>
nnoremap <leader>ts :TestSuite<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tv :TestVisit<CR>

" Shortcuts for Vista code browser
"nnoremap <leader>v :Vista!!<CR>

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

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Select current item on pressing enter
" This doesn't seem to work properly with intelephpense - when entering a 
" PHPDoc comment, it writes the comment but deletes a bunch of code.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : '<C-g>u<CR><c-r>=coc#on_enter()<CR>'

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>
"nnoremap <silent> K :call CocActionAsync('doHover')<CR>
nnoremap <silent><nowait> <leader>s :CocList -I symbols<CR>

" Navigate CoC diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>rf <Plug>(coc-refactor)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)
" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

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

nnoremap <leader><leader>q :call QFixToggle()<cr>
nnoremap <leader>f :call FoldColumnToggle()<cr>

nnoremap <leader>ve :vsplit $MYVIMRC<CR>
nnoremap <leader>vs :source $MYVIMRC<CR>

nnoremap <leader>pb :belowright vsplit bufname("#")<CR>
nnoremap <leader>w :match Error /\v +$/<CR>
nnoremap <leader>W :match none<CR>
nnoremap / /\v
"nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>
"nnoremap <leader>a :cprevious
"nnoremap <leader>s :cnext

" End Key Bindings ---}}}


" Plugin Config ---{{{

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

" Vista outline viewer
"let g:vista_icon_indent = ["▸ ", ""]
"let g:vista#renderer#enable_icon = 1

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

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Custom tagbar toggle that also focuses the tagbar.
" Need the exec to load the plugin on demand, because it slows things down.
command! -nargs=0 TagbarFocusToggle if exists('*tagbar#ToggleWindow') | call tagbar#ToggleWindow('f') | else | execute ":TagbarOpenAutoClose"| endif

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

" vim-test settings
let g:test#runner_commands = ['PHPUnit', 'Nose']
let test#strategy = 'vimterminal'
if has('win32')
    " Windows cmd.exe doesn't like ./vendor/bin/
    let test#php#phpunit#executable = 'vendor\bin\phpunit.bat'
endif

" phpunit settings
"let g:phpunit_tmpfile = expand("~/AppData/Local/Temp/vim_phpunit.out")

" End Plugin Config ---}}}

menu .1 &Utility.BufExplorer :ToggleBufExplorer<CR>
menu .2 &Utility.NERDTree :NERDTreeToggle<CR>
menu .3 &Utility.Tagbar :TagbarFocusToggle<CR>
menu .4 &Utility.Fix\ Trailing\ Space :FixTrailingSpace<CR>

menu .1 &CoC.List\ Diagnostics :CocList diagnostics<CR>
menu .2 &CoC.Outline :CocList outline<CR>
menu .3 &CoC.Commands :CocList commands<CR>
menu .4 &CoC.Extensions :CocList extensions<CR>

" Make Twig templates use Django syntax
augroup FileExtensions
    autocmd!
    autocmd BufNewFile,BufRead *.html.twig set syntax=htmldjango
augroup END

" Settings from Learn VimScript the Hard Way -----{{{

iabbrev funciton function
iabbrev functino function

iabbrev jasit it("", function() {<CR><CR>}
iabbrev jasdesc describe("", function() {<CR><CR>}

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
