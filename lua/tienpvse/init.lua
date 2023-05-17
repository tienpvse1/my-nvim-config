vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.wo.number = true



vim.opt.tabstop = 2
vim.opt.softtabstop = 2 -- install package manager
vim.opt.shiftwidth = 2
vim.o.clipboard = "unnamedplus"
vim.opt.clipboard = "unnamedplus"

--    https://github.com/folke/lazy.nvim
--
--    `:help lazy.nvim.txt` for more info
print(vim.fn.stdpath 'data' .. '/lazy/lazy.nvim')
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	'dyng/ctrlsf.vim',
	{
		'nvim-lualine/lualine.nvim',
		config = function ()
			require('lualine').setup()
		end
	},
	{ 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
	{
		"nvim-tree/nvim-tree.lua",
		config = function ()
				require('nvim-tree').setup()
				require('tienpvse.nvim_tree_customization')
		end
	},
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		'nvim-tree/nvim-web-devicons',
		config = function ()
			require('nvim-web-devicons').setup()
		end
	},
	{
		-- Theme inspired by Atom
		'navarasu/onedark.nvim',
		priority = 1000,
		config = function()
			vim.cmd.colorscheme 'onedark'
		end,
	},
	{
		'lewis6991/gitsigns.nvim',
		config = function ()
			require('tienpvse.git_sign')
			return true
		end
	},
	{
		"neoclide/coc.nvim",
		branch = "master",
		build = "yarn install --frozen-lockfile",
		filetype = {"ts", "tsx", 'js','typescriptreact', 'jsx'}
	},
	{
		"windwp/nvim-autopairs",
		config = function ()
			require("nvim-autopairs").setup()
		end,
	},
	{
		 'prettier/vim-prettier',
			build = 'yarn install --frozen-lockfile'
	},
	{
		'akinsho/toggleterm.nvim', version = "*", config = function ()
			require('toggleterm').setup()
			return true
		end
	}

})


vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.updatetime = 300

vim.opt.signcolumn = "yes"

local keyset = vim.keymap.set

function _G.check_back_space()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")

keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})

function _G.show_docs()
	local cw = vim.fn.expand('<cword>')
	if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
		vim.api.nvim_command('h ' .. cw)
	elseif vim.api.nvim_eval('coc#rpc#ready()') then
		vim.fn.CocActionAsync('doHover')
	else
		vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
	end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
	group = "CocGroup",
	command = "silent call CocActionAsync('highlight')",
	desc = "Highlight symbol under cursor on CursorHold"
})

keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})

vim.api.nvim_create_autocmd("FileType", {
	group = "CocGroup",
	pattern = "typescript,json",
	command = "setl formatexpr=CocAction('formatSelected')",
	desc = "Setup formatexpr specified filetype(s)."
})

vim.api.nvim_create_autocmd("User", {
	group = "CocGroup",
	pattern = "CocJumpPlaceholder",
	command = "call CocActionAsync('showSignatureHelp')",
	desc = "Update signature help on jump placeholder"
})

local opts = {silent = true, nowait = true}
keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)

keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)

keyset("n", "<leader>ac", "<Plug>(coc-codeaction)", opts)

keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)

local opts = {silent = true, nowait = true, expr = true}
keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
keyset("i", "<C-f>",
'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keyset("i", "<C-b>",
'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})

vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

local opts = {silent = true, nowait = true}

keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)

keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)

keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)

keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)

keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)

keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)

keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)

keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)
keyset('n', '<C-b>', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
keyset('n', '<C-E>', ':NvimTreeFocus<CR>', {noremap = true, silent = true})


