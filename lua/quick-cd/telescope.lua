local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

---Telescope picker for quick-cd
---@param theme string? Telescope theme for the picker
local function picker(theme)
	local results = {}
	for k, _ in pairs(require("quick-cd.points")) do
		table.insert(results, k)
	end

	vim.print(vim.inspect())

	local opts = {}

	if theme then
		local ok, res = pcall(function()
			return require("telescope.themes")["get_" .. theme]()
		end)

		if not ok then
			vim.print("[" .. require("quick-cd.utils").PLUGIN_NAME .. "] Invalid theme for picker: " .. theme)
			return
		end

		opts = vim.tbl_deep_extend("force", opts, res)
	end

	pickers
		.new(opts, {
			prompt_title = "colors",
			finder = finders.new_table({
				results = results,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					if selection and selection[1] then
						--- NOTE: schedule to show output, without telescope clearing it before it can be seen
						vim.schedule(function()
							vim.cmd("Qcd " .. selection[1])
						end)
					end
				end)
				return true
			end,
		})
		:find()
end

return picker
