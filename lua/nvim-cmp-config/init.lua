local status_ok, cmp = pcall(require, 'cmp')
if not status_ok then
	return
end

local luasnip = require('luasnip')

cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	view = {
		entries = {
			name = 'custom',
			selection_order = 'near_cursor'
		}
	},
	mapping = cmp.mapping.preset.insert({
		-- ['<C-p>']     = cmp.mapping.scroll_docs(-4),
		-- ['<C-n>']     = cmp.mapping.scroll_docs(4),
		-- ['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>']     = cmp.mapping.abort(),
		['<CR>']      = cmp.mapping.confirm({ select = true }),
		['<Tab>']     = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, {'i', 's'}),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {'i', 's'})
		-- source: https://github.com/Abstract-IDE/Abstract/blob/main/lua/plugins/nvim-cmp.lua
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip'  },
		{ name = 'buffer'   },
		{ name = 'path'     },
	}),
	formatting = {
		format = require('lspkind').cmp_format({
			mode     = 'symbol_text',
			maxwidth = 35,
			menu     = {
				buffer   = '[BUF]',
				nvim_lsp = '[LSP]',
				luasnip  = '[SNP]',
				path     = '[PTH]',
			}
		})
	}
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
			{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
			{
				name = 'cmdline',
				option = {
					ignore_cmds = { 'Man', '!' }
				}
			}
		}
	)
})

-- -- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
-- 	capabilities = capabilities
-- }
