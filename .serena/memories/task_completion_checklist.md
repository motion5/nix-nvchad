# Task Completion Checklist

When completing tasks in this project:

1. **Format code**: Run `stylua` on modified Lua files
2. **Verify syntax**: Lua syntax errors will show as LSP diagnostics
3. **Test in Neovim**: Open nvim and verify configuration loads without errors
4. **Check lazy.nvim**: If plugins changed, run `:Lazy sync`

Note: The "undefined global vim" warnings in diagnostics are expected - they occur because the Lua language server doesn't know about Neovim's globals. These can be ignored or suppressed with LSP config.
