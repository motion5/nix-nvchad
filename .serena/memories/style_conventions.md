# Code Style and Conventions

## Lua Formatting (stylua.toml)
- Column width: 120
- Line endings: Unix
- Indent: 2 spaces
- Quote style: AutoPreferDouble
- Call parentheses: None (e.g., `require "module"` not `require("module")`)

## NvChad Patterns
- Plugin configs go in `lua/configs/`
- Plugins defined in `lua/plugins/init.lua` 
- Options extend `nvchad.options`
- Mappings extend `nvchad.mappings`
- Use `map = vim.keymap.set` for keybindings

## Keybinding Style
- Leader key: Space
- Use descriptive `desc` field
- Group by functionality (dap, terminal, etc.)
