-- NVIM-specific configuration, i.e. stuff that doesn't work in Vim.

-- Stolen from https://xnacly.me/posts/2023/remap-copilot-nvim/
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- This config was suggested by CoPilot
require("nvim-tree").setup()

--vim.g.copilot_no_tab_map = true

require("CopilotChat").setup {
  -- See Configuration section for options
   mappings = {
    complete = {
      detail = 'Use @<Tab> or /<Tab> for options.',
      insert ='<S-Tab>',
    }
  },
}
-- The default tab mapping conflicts with coc.nvim, so we use <C-Tab> instead
--map('i', '<C-Tab>', 'copilot#Accept("<CR>")', { expr = true, silent = true })

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Keyboard users
vim.keymap.set("n", "<leader>m", function()
  require("menu").open("default")
end, {})

-- mouse users + nvimtree users!
vim.keymap.set(
    { "n", "v" },
    "<RightMouse>",
    function()
      require('menu.utils').delete_old_menus()

      vim.cmd.exec '"normal! \\<RightMouse>"'

      -- clicked buf
      local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
      local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

      require("menu").open(options, { mouse = true })
    end,
    {}
)

local custom_menu = {
  {
    name = "Format Buffer",
    cmd = function()
      local ok, conform = pcall(require, "conform")

      if ok then
        conform.format { lsp_fallback = true }
      else
        vim.lsp.buf.format()
      end
    end,
    rtxt = "<leader>fm",
  },

  {
    name = "Code Actions",
    cmd = vim.lsp.buf.code_action,
    rtxt = "<leader>ca",
  },

  { name = "separator" },

  {
    name = "  Lsp Actions",
    hl = "Exblue",
    items = "lsp",
  },

  {
    name = "Copilot Actions",
    cmd = function ()
      vim.cmd "CopilotChatOpen"
    end,
  },


  { name = "separator" },

  {
    name = "Edit Config",
    cmd = function()
      vim.cmd "tabnew"
      local conf = vim.fn.stdpath "config"
      vim.cmd("tcd " .. conf .. " | e init.lua")
    end,
    rtxt = "ed",
  },

  {
    name = "Copy Content",
    cmd = "%y+",
    rtxt = "<C-c>",
  },

  {
    name = "Delete Content",
    cmd = "%d",
    rtxt = "dc",
  },

  { name = "separator" },

  {
    name = "  Open in terminal",
    hl = "ExRed",
    cmd = function()
      local old_buf = require("menu.state").old_data.buf
      local old_bufname = vim.api.nvim_buf_get_name(old_buf)
      local old_buf_dir = vim.fn.fnamemodify(old_bufname, ":h")

      local cmd = "cd " .. old_buf_dir

      -- base46_cache var is an indicator of nvui user!
      if vim.g.base46_cache then
        require("nvchad.term").new { cmd = cmd, pos = "sp" }
      else
        vim.cmd "enew"
        vim.fn.termopen { vim.o.shell, "-c", cmd .. " ; " .. vim.o.shell }
      end
    end,
  },

  { name = "separator" },

  {
    name = "  Color Picker",
    cmd = function()
      require("minty.huefy").open()
    end,
  },
}

--require("menu").setup({
  --custom_menu = custom_menu,
--})

