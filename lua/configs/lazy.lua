return {
  defaults = { lazy = true },
  install = { colorscheme = { "nvchad" } },

  -- A nix rebuild re-links every file under ~/.config/nvim, which lazy.nvim's
  -- change detection sees as the whole config being deleted and recreated. It
  -- then prints a "Config Change Detected" report and a hit-enter prompt in
  -- every open nvim instance — once per pane, so a rebuild with many tmux
  -- sessions open means dismissing it 10+ times. Keep the reload, drop the
  -- notification.
  change_detection = { enabled = true, notify = false },

  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
}
