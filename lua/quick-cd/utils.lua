--- Common functionality used throughout the plugin
local utils = {}

utils.PLUGIN_NAME = "quick-cd"

--- Joins a `Path` into a single string
---
---`{ "home", "user", ".config", "neovim"}`
---
--- becomes
---
--- `/home/user/.config/neovim`
---
---@param path Path
---@return string
function utils.join_path(path)
	local output = ""
	for _, p in ipairs(path) do
		output = output .. "/" .. p
	end

	return output
end

--- Takes a path in form of a string and turns it into a `Path`
---@param str string
---@return Path
function utils.to_path(str)
	local parts = {}
	for match in (str .. "/"):gmatch("([^" .. "/" .. "]+)") do
		table.insert(parts, match)
	end
	return parts
end

--- Deep-copies a table recursively
---@param orig table
---@return table
function utils.deepcopy(orig)
	-- Source - https://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value
	-- Posted by Jon Ericson, modified by community. See post 'Timeline' for change history
	-- Retrieved 2025-12-07, License - CC BY-SA 3.0
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[utils.deepcopy(orig_key)] = utils.deepcopy(orig_value)
		end
		setmetatable(copy, utils.deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

--- Switch to a specific directory
---@param dir Path
function utils.change_to_dir(dir)
	local path = utils.join_path(dir)

	vim.cmd("cd " .. path)
end

--- Get the current working directory as a `Path`
---@return Path
function utils.cwd()
	local cwd = io.popen("pwd"):read("*l")

	return utils.to_path(cwd)
end

--- Gets the `Path` of the current buffer falling back to the `cwd` if that fails
---@return Path
function utils.buffer_path()
	local path_str = vim.api.nvim_buf_get_name(0)

	if #path_str == 0 then
		return utils.cwd()
	end

	local buf_path = utils.to_path(path_str)

	local path = {}

	for i = 1, #buf_path - 1 do
		table.insert(path, buf_path[i])
	end

	return path
end

--- Get the parent directories of the given `Path`
---
--- ## Example
---
--- `{ "home", "user", "config" }`
---
--- returns
---
--- ```
--- {
---     { "home" },
---     { "home", "user" },
---     { "home", "user", "config" },
--- }
---
--- ```
---
---@param dir Path
---@return Path[]
function utils.dir_parents(dir)
	local current_path = {}
	local paths = {}
	for _, v in ipairs(dir) do
		table.insert(current_path, v)

		table.insert(paths, utils.deepcopy(current_path))
	end

	return paths
end

--- Same as `utils.dir_parents` but returned table is reversed
---@param dir Path
---@return Path[]
function utils.dir_parents_rev(dir)
	local paths = utils.dir_parents(dir)

	local reversed = {}
	for i = #paths, 1, -1 do
		table.insert(reversed, paths[i])
	end

	return reversed
end

--- Returns all `Path`s, which are parents of `path` which contain `file`
---
--- See `file_in_dir`
---
---@param file string
---@param path Path
---@return Path[]?
function utils.file_in_parent_dirs(file, path)
	local parents = utils.dir_parents_rev(path)

	local locations = {}
	for _, parent in ipairs(parents) do
		if utils.file_in_dir(file, parent) then
			table.insert(locations, parent)
		end
	end

	return locations
end

--- Checks if `file` in the dir `path`
---
--- Returns `nil` if `ls` command fails
---@param file string
---@param path Path
---@return boolean?
function utils.file_in_dir(file, path)
	local path_str = utils.join_path(path)

	local handle = io.popen("ls -1 " .. "'" .. path_str .. "'")

	if not handle then
		return
	end

	repeat
		local current_file = handle:read("*l")

		if current_file == file then
			return true
		end

	until not current_file
end

---Helper to print failed messages
---@param str string
function utils.print_failed(str)
	vim.print("[" .. utils.PLUGIN_NAME .. "] Failed to cd to " .. str)
end

---Helper to create a description for a `Point`
---@param str string
function utils.make_point_desc(str)
	return "[" .. utils.PLUGIN_NAME .. "] " .. str
end

return utils
