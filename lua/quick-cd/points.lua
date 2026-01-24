--- The different points the plugin supports jumping to
---
--- Each point that can be jumped to is defined as a function on this table.

---@class Point
---@field fn function Function called to cd
---@field desc string Description of the point

---@type {[string]: Point}
local points = {}

local utils = require("quick-cd.utils")

points.git = {
	desc = utils.make_point_desc("Root directory of the git repository"),
	fn = function()
		local handle = io.popen("git rev-parse --show-toplevel 2> /dev/null")

		if not handle then
			vim.cmd("echo 'Failed to get git root dir.'")
			return
		end

		---@type string?
		local root_dir = handle:read("*l")
		handle:close()
		if not root_dir then
			utils.print_failed("git repo root. Are you in a git repo?")
			return
		end

		utils.change_to_dir(utils.to_path(root_dir))
	end,
}

points.rust_crate = {
	desc = utils.make_point_desc("Crate Cargo.toml"),
	fn = function()
		local locations = utils.file_in_parent_dirs("Cargo.toml", utils.buffer_path())

		if not locations or #locations == 0 then
			utils.print_failed("rust crate root.")

			return
		end

		utils.change_to_dir(locations[1])
	end,
}

points.rust_project = {
	desc = utils.make_point_desc("Root Cargo.toml"),
	fn = function()
		local locations = utils.file_in_parent_dirs("Cargo.toml", utils.buffer_path())

		if not locations or #locations == 0 then
			utils.print_failed("rust project root.")
			return
		end

		utils.change_to_dir(locations[#locations])
	end,
}

points.buffer = {
	desc = utils.make_point_desc("Current buffer"),
	fn = function()
		utils.change_to_dir(utils.buffer_path())
	end,
}

points.npm = {
	desc = utils.make_point_desc("Root directory of npm package"),
	fn = function()
		local locations = utils.file_in_parent_dirs("package.json", utils.buffer_path())

		if not locations or #locations == 0 then
			utils.print_failed("npm package root")
			return
		end

		utils.change_to_dir(locations[1])
	end,
}

return points
