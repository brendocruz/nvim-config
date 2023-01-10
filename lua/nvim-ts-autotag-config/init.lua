local status_ok, autotag = pcall(require, 'nvim-ts-autotag')
if not status_ok then
	return
end

local filetypes = {
    'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
	'svelte', 'vue', 'tsx', 'jsx', 'rescript', 'xml', 'php', 'markdown',
	'glimmer','handlebars','hbs',
}

local skip_tags = {
	'area', 'base', 'br', 'col', 'command', 'embed', 'hr', 'img', 'slot',
	'input', 'keygen', 'link', 'meta', 'param', 'source', 'track', 'wbr','menuitem'
}

autotag.setup({
	filetypes = filetypes,
	skip_tags = skip_tags,
})




-- Enable update on insert
-- If you have that issue #19
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics,
	{
		underline = true,
		virtual_text = {
			spacing = 5,
			severity_limit = 'Warning',
		},
		update_in_insert = true,
	}
)
