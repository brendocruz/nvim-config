local status_ok, nvim_tree = pcall(require, 'nvim-tree')
if not status_ok then
	return
end

-- CALLBACKS
local lib = require("nvim-tree.lib")
local view = require("nvim-tree.view")


local function collapse_all()
    require("nvim-tree.actions.tree-modifiers.collapse-all").fn()
end

local function edit_or_open()
    -- open as vsplit on current node
    local action = "edit"
    local node = lib.get_node_at_cursor()

    -- Just copy what's done normally with vsplit
    if node.link_to and not node.nodes then
        require('nvim-tree.actions.node.open-file').fn(action, node.link_to)
        view.close() -- Close the tree if file was opened
    elseif node.nodes ~= nil then
        lib.expand_or_collapse(node)
    else
        require('nvim-tree.actions.node.open-file').fn(action, node.absolute_path)
        view.close() -- Close the tree if file was opened
    end
end

local function vsplit_preview()
	-- open as vsplit on current node
	local action = "vsplit"
	local node = lib.get_node_at_cursor()

	-- Just copy what's done normally with vsplit
	if node.link_to and not node.nodes then
		require('nvim-tree.actions.node.open-file').fn(action, node.link_to)
	elseif node.nodes ~= nil then
		lib.expand_or_collapse(node)
	else
		require('nvim-tree.actions.node.open-file').fn(action, node.absolute_path)
	end

	-- Finally refocus on tree if it was lost
	view.focus()
end




-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local HEIGHT_RATIO = 0.8  -- You can change this
local WIDTH_RATIO = 0.5   -- You can change this too

nvim_tree.setup({
	diagnostics = {
		enable = true,
		show_on_dirs = true,
	},
	filters = {
		custom = {},
		dotfiles = false,
		exclude = {},
	},
	open_on_setup = false,
	renderer = {
		add_trailing = true,
		group_empty = false,
		highlight_opened_files = 'all',
		indent_width = 2,
		root_folder_modifier = ':t',
	},
	sort_by = 'case_sensitive',
	view = {
		adaptive_size = true,
		centralize_selection = true,
		float = {
			enable = true,
			quit_on_focus_loss = true,
			open_win_config = function()
				local screen_w = vim.opt.columns:get()
				local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
				local window_w = screen_w * WIDTH_RATIO
				local window_h = screen_h * HEIGHT_RATIO
				local window_w_int = math.floor(window_w)
				local window_h_int = math.floor(window_h)
				local center_x = (screen_w - window_w) / 2
				local center_y = ((vim.opt.lines:get() - window_h) / 2)
					- vim.opt.cmdheight:get()
				
				return {
					border = 'solid',
					relative = 'editor',
					row = center_y,
					col = center_x,
					width = window_w_int,
					height = window_h_int,
					style = 'minimal',
				}
			end,
		},
		width = function()
		  return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
		end,
		hide_root_folder = false,
		mappings = {
			custom_only = false,
			list = {
				{ key = 'l', action = 'edit', action_cb = edit_or_open },
				{ key = 'L', action = 'vsplit_preview', action_cb = vsplit_preview },
				{ key = 'h', action = 'close_node'},
				{ key = 'H', action = 'collapse_all', action_cb = collapse_all },
			},
		},
		number = false,
		preserve_window_proportions = false,
		relativenumber = false,
		side = 'left',
		signcolumn = 'yes',
	},
	actions = {
		open_file = {
			quit_on_open = false
		}
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
	}
})


local opts = { noremap = true, silent = true }
-- NvimTree
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>f', ':NvimTreeFocus<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>c', ':NvimTreeCollapse<CR>', opts)
