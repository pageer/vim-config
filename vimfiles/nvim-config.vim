" NVIM-specific configuration, i.e. stuff that doesn't work in Vim.

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
