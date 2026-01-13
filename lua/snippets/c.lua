local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "agpl",
    fmt(
      [[
  /* Copyright © {}, Thomas M. Gaul.
   *
   * This file is part of {}.
   *
   * {} is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   * 
   * {} is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.
   * 
   * You should have received a copy of the GNU Affero General Public License along with {}. If not, see <https://www.gnu.org/licenses/>.
   */
  ]],
      {
        f(function(args)
          return os.date("%Y")
        end, { 1 }),
        i(1, "Program Name"),
        f(function(args)
          return args[1][1]
        end, { 1 }),
        f(function(args)
          return args[1][1]
        end, { 1 }),
        f(function(args)
          return args[1][1]
        end, { 1 }),
      }
    )
  ),
}
