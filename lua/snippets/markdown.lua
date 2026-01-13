-- lua/snippets/markdown.lua
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s(
        "mdh-default",
        fmt(
            [[
  ---
  title: "{}"
  date: {}
  ---
  <!--LTeX: enabled=false-->
  tags: {}
  
  ]],
            {
                i(1, "title"),
                f(function(args)
                    return os.date("%Y-%m-%d")
                end, { 1 }),
                i(3),
            }
        )
    ),

    s(
        "cc",
        fmt(
            [[
{} © {} by Thomas M. Gaul is licensed under CC BY-NC-SA 4.0. To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/
  ]],
            {
                i(1, "Work Title"),
                f(function(args)
                    return os.date("%Y")
                end, { 1 }),
            }
        )
    ),

    s(
        "ccg",
        fmt(
            [[
This work is licensed under CC BY-NC-SA 4.0. To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/
      ]],
            {}
        )
    ),

    s("ltex-e", fmt([[<!--LTeX: enabled=true-->]], {})),

    s("ltex-d", fmt([[<!--LTeX: enabled=false-->]], {})),

    s("-[]", fmt("- [ ] ", {})),
}
