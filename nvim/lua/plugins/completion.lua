-- Override nvim-cmp: Enter only creates a new line, Tab accepts suggestions
return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"]  = cmp.mapping.confirm({ select = false }), -- only confirms if explicitly selected; does NOT auto-select
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true })
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      })
      -- Disable auto-select so Enter never applies a suggestion unless you picked one
      opts.preselect = cmp.PreselectMode.None
      opts.completion = vim.tbl_extend("force", opts.completion or {}, {
        completeopt = "menu,menuone,noselect",
      })
      return opts
    end,
  },
}
