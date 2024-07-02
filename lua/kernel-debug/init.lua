local M = {}
-- Function to setup the plugin
function M.setup(opts)
	-- Default options
	opts = opts or {}
	print("kernel-debug.nvim loaded with options: ", vim.inspect(opts))
	-- Create the custom command
	vim.api.nvim_create_user_command("KernelDebug", function()
		M.show_popup()
	end, { nargs = 0 })
end
-- Function to create and show the pop-up
function M.show_popup()
	local Popup = require("nui.popup")
	local Layout = require("nui.layout")
	local Input = require("nui.input")
	local event = require("nui.utils.autocmd").event
	M.popup_one, M.popup_two = Popup({
		enter = true,
		border = "single",
	}), Popup({
		border = "single",
	})
	-- Create the input box
	M.input_box = Input({
		border = "single",
		position = "50%",
		size = {
			width = "100%",
			height = 3,
		},
	}, {
		prompt = "> ",
		default_value = "",
		on_close = function()
			print("Input closed!")
		end,
		on_submit = function(value)
			print("Value submitted: ", value)
		end,
		on_change = function(value)
			print("Value changed: ", value)
		end,
	})
	-- Create the nested layout for the two display boxes
	local display_layout = Layout.Box({
		Layout.Box(M.popup_one, { size = "50%" }),
		Layout.Box(M.popup_two, { size = "50%" }),
	}, { dir = "col" })
	-- Create the main layout with the display layout and the input box
	M.layout = Layout(
		{
			position = "50%",
			size = {
				width = "80%",
				height = "80%",
			},
		},
		Layout.Box({
			display_layout,
			Layout.Box(M.input_box, { size = 3 }),
		}, { dir = "col" })
	)
	-- Keybinding to close the windows
	local function close_windows()
		M.popup_one:unmount()
		M.popup_two:unmount()
		M.input_box:unmount()
		M.layout:unmount()
		M.unmap_close_key()
	end
	-- Map <leader>kq to close the windows
	vim.keymap.set(
		"n",
		"<leader>kq",
		close_windows,
		{ noremap = true, silent = true, desc = "Close Kernel Debug window" }
	)
	-- Store the function to unmap the keybinding
	M.unmap_close_key = function()
		vim.keymap.del("n", "<leader>kq")
	end
	M.layout:mount()
	M.input_box:mount()
end
return M
