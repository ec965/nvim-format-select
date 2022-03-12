# nvim-format-select

Format the current buffer by selecting a specific lsp client.

```lua
-- sync
require('nvim-format-select').formatting_sync_select('eslint')
-- async
require('nvim-format-select').formatting_select('eslint')
```
