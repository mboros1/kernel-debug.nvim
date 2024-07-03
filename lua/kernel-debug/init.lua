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
	local buf = vim.api.nvim_create_buf(false, true)
	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")
	local win_opts = {
		style = "minimal",
		relative = "editor",
		width = math.ceil(width * 0.8),
		height = math.ceil(height * 0.8),
		row = math.ceil(height * 0.1),
		col = math.ceil(width * 0.1),
	}
	local win = vim.api.nvim_open_win(buf, true, win_opts)

	local function update_buffer_with_output(output)
		vim.api.nvim_buf_set_lines(buf, -1, -1, false, output)
	end

	-- Function to close the floating window and buffer
	local function close_windows()
		vim.api.nvim_win_close(win, true)
		vim.api.nvim_buf_delete(buf, { force = true })
	end

	-- Map <leader>kq to close the windows
	vim.keymap.set(
		"n",
		"<leader>kq",
		close_windows,
		{ noremap = true, silent = true, desc = "Close Kernel Debug window" }
	)

	-- Function to run the qemu command
	local function run_qemu()
		local cmd = "ls -l" -- Replace with your qemu command

		vim.fn.jobstart(cmd, {
			stdout_buffered = true,
			stderr_buffered = true,
			on_stdout = function(_, data)
				if data then
					update_buffer_with_output(data)
				end
			end,
			on_stderr = function(_, data)
				if data then
					update_buffer_with_output(data)
				end
			end,
			on_exit = function(_, code)
				update_buffer_with_output({ "Process exited with code " .. code })
			end,
		})
	end

	-- Run the qemu command
	run_qemu()
end

return M
