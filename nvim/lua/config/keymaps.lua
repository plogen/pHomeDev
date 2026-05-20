-- Custom keymaps (on top of LazyVim defaults)
local map = vim.keymap.set

-- ── Window navigation (matches WezTerm LEADER+hjkl habit) ──
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

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
