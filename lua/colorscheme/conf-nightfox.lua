local status_ok, nightfox = pcall(require, 'nightfox')
if not status_ok then
	return
end

nightfox.setup({
	options = {
		transparent = false,
	},
})

vim.cmd("colorscheme duskfox")
