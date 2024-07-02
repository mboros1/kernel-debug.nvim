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
	M.popup_one, M.popup_two = Popup({
		enter = true,
		border = "single",
	}), Popup({
		border = "double",
	})
	M.layout = Layout(
		{
			position = "50%",
			size = {
				width = "80%",
				height = "80%",
			},
		},
		Layout.Box({
			Layout.Box(M.popup_one, { size = "40%" }),
			Layout.Box(M.popup_two, { size = "60%" }),
		}, { dir = "row" })
	)
	-- Keybinding to close the windows
	local function close_windows()
		M.popup_one:unmount()
		M.popup_two:unmount()
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
