" NeoVim inti file - just wraps _vimrc
set runtimepath^=~/.vim
let &packpath = &runtimepath
if filereadable(expand("~/_vimrc"))
  source ~/_vimrc
elseif filereadable(expand("~/.vimrc"))
  source ~/.vimrc
endif

" NVIM-specific configuration, i.e.
" stuff that doesn't work in Vim.
lua << EOF
require("CopilotChat").setup {
  -- See Configuration section for options
   mappings = {
    complete = {
      detail = 'Use @<Tab> or /<Tab> for options.',
      insert ='<S-Tab>',
    }
  },
}
EOF
