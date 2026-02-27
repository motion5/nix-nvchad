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

-- Double-tap tracking for terminal sizing
local last_v_press = 0
local last_h_press = 0
local double_tap_threshold = 500 -- milliseconds

map({ "n", "t" }, "<A-v>", function()
  local now = vim.loop.now()
  local is_double_tap = (now - last_v_press) < double_tap_threshold
  last_v_press = now

  require("nvchad.term").toggle {
    pos = "vsp",
    id = "vtoggleTerm",
    size = is_double_tap and 1.0 or 0.5,
  }
end, { desc = "terminal toggle vertical term (double-tap for full height)" })

map({ "n", "t" }, "<A-h>", function()
  local now = vim.loop.now()
  local is_double_tap = (now - last_h_press) < double_tap_threshold
  last_h_press = now

  require("nvchad.term").toggle {
    pos = "sp",
    id = "htoggleTerm",
    size = is_double_tap and 1.0 or 0.5,
  }
end, { desc = "terminal toggle horizontal term (double-tap for full width)" })

-- Double-tap tracking for terminal navigation (Ctrl+direction)
local last_ctrl_j_press = 0
local last_ctrl_k_press = 0
local last_ctrl_l_press = 0
local last_ctrl_h_press = 0

-- Ctrl+J double-tap: exit terminal and move down
map("t", "<C-j>", function()
  local now = vim.loop.now()
  local is_double_tap = (now - last_ctrl_j_press) < double_tap_threshold
  last_ctrl_j_press = now

  if is_double_tap then
    vim.cmd "stopinsert" -- exit terminal mode
    vim.cmd "wincmd j" -- move down
  end
end, { desc = "terminal exit and move down (double-tap)" })

-- Ctrl+K double-tap: exit terminal and move up
map("t", "<C-k>", function()
  local now = vim.loop.now()
  local is_double_tap = (now - last_ctrl_k_press) < double_tap_threshold
  last_ctrl_k_press = now

  if is_double_tap then
    vim.cmd "stopinsert"
    vim.cmd "wincmd k"
  end
end, { desc = "terminal exit and move up (double-tap)" })

-- Ctrl+L double-tap: exit terminal and move right
map("t", "<C-l>", function()
  local now = vim.loop.now()
  local is_double_tap = (now - last_ctrl_l_press) < double_tap_threshold
  last_ctrl_l_press = now

  if is_double_tap then
    vim.cmd "stopinsert"
    vim.cmd "wincmd l"
  end
end, { desc = "terminal exit and move right (double-tap)" })

-- Ctrl+H double-tap: exit terminal and move left
map("t", "<C-h>", function()
  local now = vim.loop.now()
  local is_double_tap = (now - last_ctrl_h_press) < double_tap_threshold
  last_ctrl_h_press = now

  if is_double_tap then
    vim.cmd "stopinsert"
    vim.cmd "wincmd h"
  end
end, { desc = "terminal exit and move left (double-tap)" })
