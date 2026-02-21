local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("lua", {
	s({ trig = "point", desc = "Create new point" }, {
		t("points."),
		i(1, "name"),
		t({ " = { ", "   desc = " }),
		i(2, "description"),
		t({ ",", "   fn = function()", "" }),
		i(3),
		t({ "", "   end,", "}" }),
	}),
})
