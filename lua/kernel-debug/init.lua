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
		on_close = function()
			print("Input closed")
		end,
		on_submit = function(value)
			print("Value submitted: ", value)
		end,
		on_change = function(value)
			print("Value changed: ", value)
		end,
	})

	-- M.layout = Layout(
	-- 	{
	-- 		position = "50%",
	-- 		size = {
	-- 			width = "80%",
	-- 			height = "90%",
	-- 		},
	-- 	},
	-- 	Layout.Box({
	-- 		Layout.Box({
	-- 			Layout.Box(M.top_left_popup, { size = { width = "45%", height = "100%" } }),
	-- 			Layout.Box(M.top_right_popup, { size = { width = "55%", height = "100%" } }),
	-- 		}, { dir = "col", size = { width = "100%", height = "90%" } }),
	-- 		Layout.Box(M.bottom_input, { size = { width = "100%", height = "10%" } }),
	-- 	}, { dir = "row" })
	-- )

	M.top_popup = Popup({ border = "double" })
	M.bottom_left_popup = Popup({ border = "single" })
	M.bottom_right_popup = Popup({ border = "single" })

	M.layout = Layout(
		{
			position = "50%",
			size = {
				width = 80,
				height = 40,
			},
		},
		Layout.Box({
			Layout.Box({
				Layout.Box(M.bottom_left_popup, { size = "50%" }),
				Layout.Box(M.bottom_right_popup, { size = "50%" }),
			}, { dir = "row", size = "60%" }),
			Layout.Box(M.bottom_input, { size = "40%" }),
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
end
return M
