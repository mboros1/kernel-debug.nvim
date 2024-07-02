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
	local popup_one, popup_two = Popup({
		enter = true,
		border = "single",
	}), Popup({
		border = "double",
	})
	local layout = Layout(
		{
			position = "50%",
			size = {
				width = 80,
				height = "60%",
			},
		},
		Layout.Box({
			Layout.Box(popup_one, { size = "40%" }),
			Layout.Box(popup_two, { size = "60%" }),
		}, { dir = "row" })
	)
	-- Keybinding to close the windows
	local function close_windows()
		popup_one:unmount()
		popup_two:unmount()
		layout:unmount()
	end
	popup_one:map("n", "<leader>q", close_windows, { noremap = true, silent = true })
	popup_two:map("n", "<leader>q", close_windows, { noremap = true, silent = true })
	layout:mount()
end
return M
