local on_attach = require('lsp.on_attach')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
	autostart = false,
	on_attach = function(client, buffer)
		client.server_capabilities.documentFormattingProvider = true
		on_attach(client, buffer)
	end,
	capabilities = capabilities,
	filetype = { 'dockerfile' },
	single_file_support = true
}
