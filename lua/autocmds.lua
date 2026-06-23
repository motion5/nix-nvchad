-- ─── Claude float persistence (Stage 2) ─────────────────────────────────────
-- On VimLeavePre: if any nvchad terminal floats are open, save their IDs and
-- the latest Claude session ID for this git repo to a per-repo JSON file.
-- On VimEnter (inside tmux only): read that file and reopen the floats, each
-- running `claude --resume <session>`. This is the reboot/resurrect path —
-- tmux-resurrect relaunches nvim, nvim opens the Claude floats automatically.

local claude_state_dir = vim.fn.expand("~/.local/state/nvim/claude-restore")

local float_defaults = { row = 0.15, col = 0.07, width = 0.85, height = 0.7 }

-- Maps nvchad filetype → { id, pos } as defined in lua/mappings.lua
local nvterm_map = {
  NvTerm_float = { id = "floatTerm",   pos = "float" },
  NvTerm_vsp   = { id = "vtoggleTerm", pos = "vsp"   },
  NvTerm_sp    = { id = "htoggleTerm", pos = "sp"    },
}

local function git_root()
  local r = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("%s+$", "")
  return r ~= "" and r or nil
end

local function state_file(root)
  return claude_state_dir .. "/" .. vim.fn.fnamemodify(root, ":t") .. ".json"
end

local function latest_session(root)
  local key = root:gsub("/", "-")
  local dir = vim.fn.expand("~/.claude/projects/") .. key
  local h = io.popen("ls -t " .. vim.fn.shellescape(dir) .. "/*.jsonl 2>/dev/null | head -1")
  if not h then return nil end
  local p = h:read("*l"); h:close()
  return (p and p ~= "") and vim.fn.fnamemodify(p, ":t:r") or nil
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  desc = "Save open Claude float state for tmux-resurrect restore",
  callback = function()
    local root = git_root()
    if not root then return end

    local open = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == "terminal" then
        local t = nvterm_map[vim.bo[buf].ft]
        if t then table.insert(open, t) end
      end
    end
    if #open == 0 then return end

    local sid = latest_session(root)
    if not sid then return end

    vim.fn.mkdir(claude_state_dir, "p")
    local f = io.open(state_file(root), "w")
    if f then
      f:write(vim.json.encode({ session_id = sid, floats = open, saved_at = os.time() }))
      f:close()
    end
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Restore Claude floats after tmux resurrect",
  callback = function()
    -- Only auto-restore inside tmux (the reboot/resurrect path).
    -- Skip when nvim was opened with explicit file args (deliberate edit session).
    if not vim.env.TMUX then return end
    if vim.fn.argc() > 0 then return end

    vim.defer_fn(function()
      local root = git_root()
      if not root then return end

      local f = io.open(state_file(root), "r")
      if not f then return end
      local content = f:read("*a"); f:close()

      local ok, state = pcall(vim.json.decode, content)
      if not ok or not state or not state.session_id then return end

      -- Stale guard: ignore saves older than 7 days
      if os.time() - (state.saved_at or 0) > 7 * 86400 then
        os.remove(state_file(root)); return
      end

      -- Use the latest session for this repo (may be newer than what was saved)
      local sid = latest_session(root) or state.session_id

      for i, fi in ipairs(state.floats or {}) do
        vim.defer_fn(function()
          local opts = { id = fi.id, pos = fi.pos, cmd = "claude --resume " .. sid }
          if fi.pos == "float" then opts.float_opts = float_defaults end
          require("nvchad.term").toggle(opts)
        end, (i - 1) * 400)
      end
    end, 900)
  end,
})
-- ─── end Claude float persistence ────────────────────────────────────────────

-- Tailscale ACL validation on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*/tailscale/acl.json",
  callback = function()
    local file_dir = vim.fn.expand("%:p:h")
    vim.fn.system("cd " .. file_dir .. " && ./validate-acl.sh")
    vim.notify("Tailscale ACL validated", vim.log.levels.INFO)
  end,
})

-- Tailscale ACL keybindings (only when editing acl.json)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function()
    local filepath = vim.fn.expand("%:p")
    if filepath:match("tailscale/acl%.json$") then
      vim.keymap.set("n", "<leader>tv", function()
        local dir = vim.fn.expand("%:p:h")
        vim.cmd("!cd " .. dir .. " && ./validate-acl.sh")
      end, { buffer = true, desc = "Validate Tailscale ACL" })

      vim.keymap.set("n", "<leader>ts", function()
        local dir = vim.fn.expand("%:p:h")
        vim.cmd("!cd " .. dir .. " && ./sync-acl.sh")
      end, { buffer = true, desc = "Sync Tailscale ACL" })

      vim.keymap.set("n", "<leader>tf", function()
        local dir = vim.fn.expand("%:p:h")
        vim.cmd("!cd " .. dir .. " && ./fetch-acl.sh")
      end, { buffer = true, desc = "Fetch Tailscale ACL" })
    end
  end,
})
