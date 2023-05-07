-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Packages
require("lazy").setup({
	-- LSP
	"neovim/nvim-lspconfig",

	-- Completions
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter, CmdlineEnter",
		config = function()
			local cmp = require("cmp")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")

			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "emoji" },
				}),
			})
		end,
	},
	{ "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
	{ "L3MON4D3/LuaSnip", event = "InsertEnter" },
	{ "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
	{ "hrsh7th/cmp-emoji", event = "InsertEnter" },

	-- Tree-sitter
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				autotag = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				highlight = {
					enable = true,
					disable = {},
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						node_decremental = "grm",
					},
				},
				ensure_installed = {
					"astro",
					"bash",
					"c",
					"clojure",
					"cpp",
					"css",
					"dockerfile",
					"go",
					"html",
					"javascript",
					"json",
					"jsonc",
					"lua",
					"make",
					"nix",
					"ocaml",
					"ocaml_interface",
					"prisma",
					"rust",
					"scheme",
					"toml",
					"typescript",
					"tsx",
					"vue",
					"yaml",
				},
			})
		end,
	},

	-- Theme
	{
		"projekt0n/github-nvim-theme",
	},
	{
		"rebelot/kanagawa.nvim",
		config = function()
			-- vim.cmd("colorscheme kanagawa-dragon")
		end,
	},
	{
		"sainnhe/sonokai",
		config = function()
			vim.cmd("colorscheme sonokai")
		end,
	},

	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 0
			require("which-key").setup({})
		end,
	},

	{
		"petertriho/nvim-scrollbar",
		event = "BufRead, BufNewFile",
		config = function()
			require("scrollbar").setup()
		end,
	},
	{
		"kevinhwang91/nvim-hlslens",
		event = "BufNewFile, BufRead",
		config = function()
			require("scrollbar.handlers.search").setup({})
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"debugloop/telescope-undo.nvim",
		},
		cmd = "Telescope",
		config = function()
			require("telescope").setup({
				extensions = {
					undo = {},
					fzf = {},
				},
			})
			require("telescope").load_extension("undo")
			require("telescope").load_extension("file_browser")
			require("telescope").load_extension("fzf")
		end,
	},

	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		keys = {
			{ "<Space>e", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>" },
		},
	},

	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},
	"ray-x/lsp_signature.nvim",
	"stevearc/dressing.nvim",
	{
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		cmd = "Trouble",
		config = function()
			require("trouble").setup({})
		end,
	},
	"machakann/vim-sandwich",
	{
		"phaazon/hop.nvim",
		branch = "v2",
	},
	{ "windwp/nvim-autopairs", event = "InsertEnter" },
	{ "windwp/nvim-ts-autotag", event = "InsertEnter" },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	},

	{
		"lewis6991/gitsigns.nvim",
		tag = "v0.6",
		event = { "BufNewFile", "BufRead" },
		config = function()
			local gitsigns = require("gitsigns")
			gitsigns.setup({
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 300,
				},
			})

			vim.keymap.set("n", "<Space>gs", gitsigns.stage_hunk)
			vim.keymap.set("n", "<Space>gj", gitsigns.next_hunk)
			vim.keymap.set("n", "<Space>gk", gitsigns.prev_hunk)
			vim.keymap.set("n", "<Space>gd", gitsigns.diffthis)

			require("scrollbar.handlers.gitsigns").setup()
		end,
	},
	"akinsho/toggleterm.nvim",
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
				},
			})
		end,
	},

	{
		"RRethy/vim-illuminate",
		event = "BufRead, BufNewFile",
	},
	{
		"akinsho/bufferline.nvim",
		tag = "v3.*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
		end,
	},

	-- Language specific
	{
		"ionide/Ionide-vim",
		ft = "fsharp",
	},
	{
		"purescript-contrib/purescript-vim",
		ft = "purescript",
	},
	{
		"Julian/lean.nvim",
	},

	"lukas-reineke/indent-blankline.nvim",
})

vim.cmd([[let g:neo_tree_remove_legacy_commands = 1]])

-- Autopairs
require("nvim-autopairs").setup({
	check_ts = true,
	enable_check_bracket_line = false,
})

-- Neo-tree
require("neo-tree").setup({
	filesystem = {
		filtered_items = {
			hide_dotfiles = false,
		},
	},
})

-- Toggleterm
require("toggleterm").setup()

-- Completions

-- Ex Commands

vim.cmd("command! -nargs=* Terminal vsplit | wincmd j | vertical resize 80 | terminal <args>")

-- Keybindings

local opts = { noremap = true, silent = true }

-- TeleScope
vim.keymap.set("n", "<Space>tt", "<cmd>Telescope<CR>")
vim.keymap.set("n", "<Space>tf", "<cmd>Telescope fd<CR>")
vim.keymap.set("n", "<Space>tg", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<Space>u", "<cmd>Telescope undo<CR>")

vim.keymap.set("n", "<Space>f", "<cmd>Neotree reveal<CR>")

-- Move focus
vim.keymap.set("n", "<Space>j", "<C-w>w")
vim.keymap.set("n", "<Space>k", "<C-w>W")

-- Hop.nvim
local hop = require("hop")
hop.setup({})

function hopword()
	local jump_target = require("hop.jump_target")

	local generator = jump_target.jump_targets_by_scanning_lines

	hop.hint_with(generator(jump_target.regex_by_searching([[\<\k\{-}\>]])), hop.opts)
end

vim.keymap.set("n", "<Space>hw", hopword)
vim.keymap.set("n", "<Space>hc", "<cmd>HopChar1<CR>")

-- Language servers

local lsp_set_keymap = function(client, bufnr)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.keymap.set("n", "<Space>lca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<Space>lrn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<Space>lf", vim.lsp.buf.format, opts)
end

local servers = {
	"rust_analyzer",
	"ocamllsp",
	"eslint",
	"prismals",
	"pyright",
	"rnix",
	"dhall_lsp_server",
	"astro",
	"elmls",
	"hls",
	"purescriptls",
	"volar",
}
for _, lsp in pairs(servers) do
	require("lspconfig")[lsp].setup({
		on_attach = function(client, bufnr)
			lsp_set_keymap(client, bufnr)
		end,
	})
end

-- In some languages we prefer to use external formatters (i.e. Prettier) rather than ones servers provide
local formatting_disabled_servers = { "jsonls", "html", "cssls", "tsserver" }
for _, lsp in pairs(formatting_disabled_servers) do
	require("lspconfig")[lsp].setup({
		on_attach = function(client, bufnr)
			lsp_set_keymap(client, bufnr)
			client.server_capabilities.document_formatting = false
		end,
	})
end

require("lspconfig").graphql.setup({
	filetypes = { "graphql", "typescript", "typescriptreact", "vue" },
})

-- Lua
require("lspconfig").lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = { globals = { "vim" } },
		},
		workspace = { library = vim.api.nvim_get_runtime_file("", true) },
		telemetry = { enable = false },
	},
	on_attach = function(client, bufnr)
		lsp_set_keymap(client, bufnr)
	end,
})

-- Parol
vim.filetype.add({
	extension = {
		par = "parol",
	},
	filename = {},
})

local configs = require("lspconfig.configs")

if not configs.parol_ls then
	configs.parol_ls = {
		default_config = {
			cmd = { "parol-ls", "--stdio" },
			filetypes = { "parol" },
			root_dir = require("lspconfig.util").root_pattern("Cargo.toml"),
			settings = {},
		},
	}
end

require("lspconfig").parol_ls.setup({
	on_attach = function(client, bufnr)
		lsp_set_keymap(client, bufnr)
	end,
})

-- SATySFi
vim.cmd("autocmd BufNewFile,BufRead *.saty set filetype=satysfi")

-- F#
vim.g["fsharp#fsautocomplete_command"] = {
	"dotnet",
	"fsautocomplete",
}

vim.g["fsharp#lsp_auto_setup"] = 0

require("ionide").setup({
	on_attach = function(client, bufnr)
		lsp_set_keymap(client, bufnr)
	end,
})

require("lean").setup({
	lsp = {
		on_attach = function(client, bufnr)
			lsp_set_keymap(client, bufnr)
		end,
	},
})

-- lsp_signature
require("lsp_signature").setup({})

-- null-ls
local nullls = require("null-ls")
nullls.setup({
	sources = {
		nullls.builtins.formatting.prettier,
		nullls.builtins.formatting.stylua,
	},
})

-- Tree-sitter
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.satysfi = {
	install_info = {
		url = "https://github.com/monaqa/tree-sitter-satysfi",
		files = { "src/parser.c", "src/scanner.c" },
	},
	filetype = "satysfi",
}

-- Indent guide

require("indent_blankline").setup({
	show_current_context = true,
	show_current_context_start = true,
})

-- General configurations

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.scrolloff = 5
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 0
vim.o.undofile = true

-- Move cursor by display line

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<Down>", "gj")
vim.keymap.set("n", "<Up>", "gk")
vim.keymap.set("i", "<Down>", "<C-o>gj")
vim.keymap.set("i", "<Up>", "<C-o>gk")

-- Cursor line highlight
vim.cmd("set cursorline")
vim.cmd("set cursorcolumn")
vim.cmd("highlight CursorColumn guibg=#163356")
vim.cmd("highlight CursorLine guibg=#163356")

-- Open terminal in insert mode
vim.cmd("autocmd TermOpen * startinsert")
