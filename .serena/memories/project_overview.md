# nix-nvchad Project Overview

## Purpose
NvChad configuration for Neovim, managed as a standalone repository. Provides a customized IDE-like experience with LSP, DAP debugging, treesitter, and various language support.

## Tech Stack
- **Editor**: Neovim with NvChad v2.5 framework
- **Language**: Lua
- **Plugin Manager**: lazy.nvim
- **Package Manager**: Mason for LSP/DAP/formatter installation

## Structure
```
init.lua              # Entry point, bootstraps lazy.nvim
lua/
  chadrc.lua          # NvChad configuration (theme, UI)
  options.lua         # Vim options
  mappings.lua        # Keybindings
  plugins/init.lua    # Plugin definitions
  configs/            # Plugin-specific configurations
    lspconfig.lua     # LSP server configurations
    conform.lua       # Formatter configurations
    lazy.lua          # lazy.nvim settings
    mason.lua         # Mason settings
```

## Language Support
Treesitter: JS/TS, Go, Rust, Python, C#, C/C++, Nix, Terraform, and more
LSP configured for multiple languages via nvim-lspconfig
DAP debugging for Go (nvim-dap-go)

## Key Features
- catppuccin theme
- nvim-tree on right side
- Format on save (conform.nvim)
- DAP debugging UI
- F# support via Ionide-vim
- C# support via roslyn.nvim
