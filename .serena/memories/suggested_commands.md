# Suggested Commands

## Formatting
```bash
stylua .              # Format all Lua files
stylua <file.lua>     # Format specific file
```

## Linting
No explicit linter configured. Rely on LSP diagnostics in Neovim.

## Testing
No automated tests. Configuration is tested by running Neovim.

## Installation
The configuration is typically symlinked or copied to `~/.config/nvim/`

## Neovim Commands
- `:Lazy` - Open lazy.nvim UI for plugin management
- `:Mason` - Open Mason UI for LSP/DAP/formatter installation
- `:checkhealth` - Verify Neovim setup

## Git
Standard git workflow. No pre-commit hooks beyond basic .git/hooks/pre-commit.
