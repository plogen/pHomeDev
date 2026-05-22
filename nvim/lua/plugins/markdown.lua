-- Markdown rendering inside Neovim buffers
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "md" },
    opts = {
      enabled = true,
      render_modes = { "n", "c" },
      heading = { enabled = true },
      code = { enabled = true, style = "full" },
      bullet = { enabled = true },
      checkbox = { enabled = true },
      table = { enabled = true },
      link = { enabled = true },
    },
  },

  -- Paste images from clipboard: saves file and inserts markdown link (<leader>mp)
  {
    "HakonHarnes/img-clip.nvim",
    event = "BufEnter",
    opts = {
      default = {
        dir_path = "assets",
        file_name = "%Y-%m-%d-%H-%M-%S",
        use_absolute_path = false,
      },
    },
    keys = {
      { "<leader>mp", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
    },
  },
}
