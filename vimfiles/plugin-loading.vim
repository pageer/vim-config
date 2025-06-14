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
    Plug 'HerringtonDarkholme/yats.vim'   " TypeScript syntax
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
    "if has("lua")
        "Plug 'obaland/vfiler.vim'
        "Plug 'obaland/vfiler-column-devicons'
    "endif
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
    Plug 'github/copilot.vim', {'branch': 'release'}
    if has("nvim")
        Plug 'nvim-lua/plenary.nvim'
        Plug 'CopilotC-Nvim/CopilotChat.nvim', {'branch': 'main'}
        Plug 'nvzone/volt', {'branch': 'main'}
        Plug 'nvzone/menu', {'branch': 'main'}
    endif

    " Themes
    "Plug 'ayu-theme/ayu-vim'
    "Plug 'drewtempelmeyer/palenight.vim'
    Plug 'morhetz/gruvbox'

call plug#end()
" End Plug plugins ---}}}
