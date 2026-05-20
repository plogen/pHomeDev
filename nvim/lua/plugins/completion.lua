-- Override blink.cmp: Enter creates a new line, Tab accepts suggestions
return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<CR>"]    = {},                              -- remove Enter from accepting
        ["<Tab>"]   = { "accept", "fallback" },        -- Tab accepts
        ["<S-Tab>"] = { "select_prev", "fallback" },   -- Shift+Tab navigates up
        ["<C-n>"]   = { "select_next", "fallback" },   -- Ctrl+n navigates down
        ["<C-p>"]   = { "select_prev", "fallback" },   -- Ctrl+p navigates up
        ["<C-e>"]   = { "cancel", "fallback" },        -- Ctrl+e dismisses
      },
    },
  },
}

