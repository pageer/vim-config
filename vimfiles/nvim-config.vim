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

-- Keyboard users
vim.keymap.set("n", "<leader>m", function()
  require("menu").open("default")
end, {})

-- mouse users + nvimtree users!
vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
  require('menu.utils').delete_old_menus()

  vim.cmd.exec '"normal! \\<RightMouse>"'

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

  require("menu").open(options, { mouse = true })
end, {})

EOF
