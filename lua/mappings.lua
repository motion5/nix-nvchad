require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- Telescope: toggle hidden-dir search on <leader>ff
-- Defaults ON; excludes .git and node_modules; depth-limited to avoid noise
local _ff_hidden = true
map("n", "<leader>ff", function()
  _ff_hidden = not _ff_hidden
  require("telescope.builtin").find_files {
    hidden = _ff_hidden,
    find_command = _ff_hidden and {
      "fd", "--type", "f",
      "--hidden",
      "--exclude", ".git",
      "--exclude", "node_modules",
      "--max-depth", "6",
    } or nil,
    prompt_title = _ff_hidden and "Files (hidden)" or "Files",
  }
  vim.notify("find_files hidden: " .. tostring(_ff_hidden), vim.log.levels.INFO)
end, { desc = "telescope find files (toggle hidden)" })

-- Live grep including hidden dirs, excluding .git
map("n", "<leader>fW", function()
  require("telescope.builtin").live_grep {
    additional_args = { "--hidden", "--glob", "!**/.git/**" },
    prompt_title = "Grep (hidden)",
  }
end, { desc = "telescope live grep (hidden)" })

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

-- Terminal splits: Alt+H/V to toggle, double-tap for full size
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
end, { desc = "terminal vertical (double-tap: full)" })

map({ "n", "t" }, "<A-h>", function()
  local now = vim.loop.now()
  local is_double_tap = (now - last_h_press) < double_tap_threshold
  last_h_press = now

  require("nvchad.term").toggle {
    pos = "sp",
    id = "htoggleTerm",
    size = is_double_tap and 1.0 or 0.5,
  }
end, { desc = "terminal horizontal (double-tap: full)" })

-- TODO: Terminal exit-and-navigate bindings (Ctrl+Shift+J/K/L/H)
-- Parked: needs Kitty keyboard protocol investigation. See nix-dotfiles/todo.md
