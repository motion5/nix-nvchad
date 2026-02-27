require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

local showCompletion = function()
  local cmp = require "cmp"
  local res = cmp.visible()

  if not res then
    cmp.complete()
  end
end

map("i", "<A-Enter>", showCompletion)
map("n", "<A-Enter>", showCompletion)

--
--

map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Add breakpoint at line" })
map("n", "<leader>dus", function()
  local widgets = require "dap.ui.widgets"
  local sidebar = widgets.sidebar(widgets.scope)
  sidebar.open()
end, { desc = "Open debugging sidebar" })
map("n", "<leader>dst", function()
  require("dap").continue()
end, { desc = "Start debugging" })

-- dap go
map("n", "<leader>dgt", function()
  require("dap-go").debug_test()
end, { desc = "Debug go test" })
map("n", "<leader>dgl", function()
  require("dap-go").debug_last()
end, { desc = "Debug last go test" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle {
    pos = "float",
    id = "floatTerm",
    float_opts = {
      row = 0.15,
      col = 0.07,
      width = 0.85,
      height = 0.7,
    },
  }
end, { desc = "terminal toggle floating term" })

-- Terminal splits: Alt+direction for 50%, Alt+Shift for full size
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle {
    pos = "vsp",
    id = "vtoggleTerm",
    size = 0.5,
  }
end, { desc = "terminal toggle vertical term (50%)" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle {
    pos = "sp",
    id = "htoggleTerm",
    size = 0.5,
  }
end, { desc = "terminal toggle horizontal term (50%)" })

map({ "n", "t" }, "<A-S-v>", function()
  require("nvchad.term").toggle {
    pos = "vsp",
    id = "vtoggleTerm",
    size = 1.0,
  }
end, { desc = "terminal toggle vertical term (full)" })

map({ "n", "t" }, "<A-S-h>", function()
  require("nvchad.term").toggle {
    pos = "sp",
    id = "htoggleTerm",
    size = 1.0,
  }
end, { desc = "terminal toggle horizontal term (full)" })

-- Ctrl+Alt+direction: exit terminal and navigate to adjacent window
map("t", "<C-A-j>", function()
  vim.cmd "stopinsert"
  vim.cmd "wincmd j"
end, { desc = "terminal exit and move down" })

map("t", "<C-A-k>", function()
  vim.cmd "stopinsert"
  vim.cmd "wincmd k"
end, { desc = "terminal exit and move up" })

map("t", "<C-A-l>", function()
  vim.cmd "stopinsert"
  vim.cmd "wincmd l"
end, { desc = "terminal exit and move right" })

map("t", "<C-A-h>", function()
  vim.cmd "stopinsert"
  vim.cmd "wincmd h"
end, { desc = "terminal exit and move left" })
