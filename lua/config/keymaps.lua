local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "<Leader>w", ":update<Return>", opts)
keymap.set("n", "<Leader>q", ":quit<Return>", opts)
keymap.set("n", "<Leader>Q", ":qa<Return>", opts)

keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)

keymap.set("n", "<C-S-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap.set("n", "<C-S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
keymap.set("n", "<C-S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap.set("n", "<C-S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

keymap.set("i", "@", "@<C-x><C-o>", { silent = true, buffer = true })
keymap.set("i", "#", "#<C-x><C-o>", { silent = true, buffer = true })

keymap.set("i", "<C-k>t", "├── ", { desc = "Tree branch" })
keymap.set("i", "<C-k>l", "└── ", { desc = "Tree last branch" })
keymap.set("i", "<C-k>v", "│   ", { desc = "Tree vertical" })
