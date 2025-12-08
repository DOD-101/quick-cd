local points = require("quick-cd.points")

vim.api.nvim_create_user_command("Qcd", function(opts)
	local utils = require("quick-cd.utils")

	local point = points[opts.args]

	if not point then
		vim.print("[" .. utils.PLUGIN_NAME .. "] No such point to jump to.")
		return
	end

	point.fn()
end, {
	desc = "Quick cd",
	nargs = 1,
	complete = function()
		local options = {}
		for k, _ in pairs(points) do
			table.insert(options, k)
		end

		return options
	end,
})
