# quick-cd

> A tiny plugin to quickly change your cwd in neovim

## Usage 

```lua
local qcdp = require("quick-cd").points

vim.keymap.set("n", "gj0", function()
    qcdp.git_root.fn()
end, { desc = qcdp.git_root.desc })
```

## Contributing 

If you can think of other useful places people might want to cd to please contribute them in `./lua/quick-cd/points.lua` or if your unsure of your lua skills feel free to make an issue.

## License 

This project is licensed under the [Unlicense](https://unlicense.org/). 
