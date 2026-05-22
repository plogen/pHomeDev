-- Custom keymaps (on top of LazyVim defaults)
local map = vim.keymap.set

-- ── Seamless navigation between Neovim splits and WezTerm panes ──
-- CTRL+hjkl moves between Neovim windows when a split exists in that direction;
-- when at the edge it calls `wezterm cli` so WezTerm navigates to the next pane.
-- WezTerm is configured to forward CTRL+hjkl to Neovim when it is the active
-- process, completing the seamless round-trip.
local wez_dirs = { h = "Left", j = "Down", k = "Up", l = "Right" }
local vim_dirs = { h = "h",    j = "j",    k = "k",  l = "l" }

for key, wez_dir in pairs(wez_dirs) do
  map("n", "<C-" .. key .. ">", function()
    local cur = vim.fn.winnr()
    vim.cmd("wincmd " .. vim_dirs[key])
    if vim.fn.winnr() == cur then
      -- At the edge of Neovim splits — hand off to WezTerm
      vim.fn.jobstart({ "wezterm", "cli", "activate-pane-direction", wez_dir })
    end
  end, { desc = "Move " .. wez_dir:lower() .. " (Neovim → WezTerm)" })
end

-- ── Resize splits with arrows ──
map("n", "<C-Up>",    ":resize +2<CR>",          { desc = "Increase split height" })
map("n", "<C-Down>",  ":resize -2<CR>",          { desc = "Decrease split height" })
map("n", "<C-Left>",  ":vertical resize -2<CR>", { desc = "Decrease split width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase split width" })

-- ── Buffer navigation ──
map("n", "<Tab>",   ":bnext<CR>",     { desc = "Next buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- ── Quick save / quit ──
map("n", "<leader>w", ":w<CR>",  { desc = "Save" })
map("n", "<leader>q", ":q<CR>",  { desc = "Quit" })
map("n", "<leader>Q", ":qa!<CR>",{ desc = "Quit all" })

-- ── Markdown preview toggle ──
map("n", "<leader>mp", ":RenderMarkdown toggle<CR>", { desc = "Toggle Markdown render" })
