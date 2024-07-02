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
	-- Keybinding to open the pop-up
	vim.keymap.set("n", "<leader>kd", M.show_popup, { desc = "Open Kernel Debug window" })
	-- Keybinding to close the pop-up
	vim.keymap.set("n", "<leader>kq", M.close_popup, { desc = "Close Kernel Debug window" })
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
				width = 80,
				height = "60%",
			},
		},
		Layout.Box({
			Layout.Box(M.popup_one, { size = "40%" }),
			Layout.Box(M.popup_two, { size = "60%" }),
		}, { dir = "row" })
	)
	M.layout:mount()
end
-- Function to close the pop-up
function M.close_popup()
	if M.popup_one and M.popup_two and M.layout then
		M.popup_one:unmount()
		M.popup_two:unmount()
		M.layout:unmount()
	end
end
return M
