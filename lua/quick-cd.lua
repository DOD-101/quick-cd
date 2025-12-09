-- Types for plugin

--- A path in list form
---
--- `/home/user/.config/neovim`
---
--- is
---
--- `{ "home", "user", ".config", "neovim"}`
---
---@alias Path string[]
---

--- Options passed to setup
---
--- @class SetupOpts
--- @field points {[string]: Point} Additional points

-- Main plugin code

local plugin = {}

---Setup function to load the plugin
---@param opts SetupOpts
function plugin.setup(opts)
	plugin.utils = require("quick-cd.utils")
	plugin.points = require("quick-cd.points")

	if opts.points then
		for k, v in pairs(opts.points) do
			plugin.points[k] = v
		end
	end

	require("quick-cd.cmd")
end

return plugin
