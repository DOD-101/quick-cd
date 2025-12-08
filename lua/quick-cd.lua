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

-- Main plugin code

local plugin = {}

plugin.utils = require("quick-cd.utils")
plugin.points = require("quick-cd.points")

require("quick-cd.cmd")

return plugin
