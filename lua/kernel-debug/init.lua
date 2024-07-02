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

	M.top_left_popup = Popup({ border = "single" })
	M.top_right_popup = Popup({ border = "single" })
	M.bottom_input = Input({
		border = "single",
	}, {
		prompt = "> ",
		default_value = "",
		on_change = function(value)
			print("Value submitted: ", value)
		end,
	})

	M.layout = Layout(
		{
			position = "50%",
			size = {
				width = "90%",
				height = "90%",
			},
		},
		Layout.Box({
			Layout.Box({
				Layout.Box(M.top_left_popup, { size = "55%" }),
				Layout.Box(M.top_right_popup, { size = "45%" }),
			}, { dir = "row", size = "95%" }),
			Layout.Box(M.bottom_input, { size = "5%" }),
		}, { dir = "col" })
	)

	-- Keybinding to close the windows
	local function close_windows()
		M.top_right_popup:unmount()
		M.top_left_popup:unmount()
		M.input_box:unmount()
		M.layout:unmount()
	end
	-- Map <leader>kq to close the windows
	vim.keymap.set(
		"n",
		"<leader>kq",
		close_windows,
		{ noremap = true, silent = true, desc = "Close Kernel Debug window" }
	)
	M.layout:mount()
end
return M
