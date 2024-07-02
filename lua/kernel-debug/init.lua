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
	local current_dir = "row"
	popup_one:map("n", "r", function()
		if current_dir == "col" then
			layout:update(Layout.Box({
				Layout.Box(popup_one, { size = "40%" }),
				Layout.Box(popup_two, { size = "60%" }),
			}, { dir = "row" }))
			current_dir = "row"
		else
			layout:update(Layout.Box({
				Layout.Box(popup_two, { size = "60%" }),
				Layout.Box(popup_one, { size = "40%" }),
			}, { dir = "col" }))
			current_dir = "col"
		end
	end, {})
	layout:mount()
end
return M
