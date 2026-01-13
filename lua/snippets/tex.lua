-- lua/snippets/tex.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- Helper function: wrap selected text in environment
local function wrap_env(args, _, env_name)
    return sn(nil, {
        t("\\begin{" .. env_name .. "}\n\t"),
        i(1),
        t("\n\\end{" .. env_name .. "}"),
    })
end

return {
    -- Begin-end environments
    s(
        "beg",
        fmt(
            [[
\begin{{{}}}
    {}
\end{{{}}}
  ]],
            {
                i(1, "environment"),
                i(2),
                f(function(args)
                    return args[1][1]
                end, { 1 }),
            }
        )
    ),

    -- Inline math
    s("dm", fmt("$ {} $", { i(1) })),
    s("dmq", fmt("$$\n{}\n$$", { i(1) })),

    -- Itemize environment
    s(
        "itemize",
        fmt(
            [[
\begin{{itemize}}
    \item {}
\end{{itemize}}
  ]],
            { i(1) }
        )
    ),

    -- Enumerate environment
    s(
        "enum",
        fmt(
            [[
\begin{{enumerate}}
    \item {}
\end{{enumerate}}
  ]],
            { i(1) }
        )
    ),

    -- Figure environment
    s(
        "fig",
        fmt(
            [[
\begin{{figure}}[ht]
    \centering
    \includegraphics[width=\\linewidth]{{{}}}
    \caption{{{}}}
    \label{{fig:{}}}
\end{{figure}}
  ]],
            { i(1, "image.png"), i(2, "Caption"), i(3, "label") }
        )
    ),

    -- Section snippet
    s("sec", fmt("\\section{{{}}}", { i(1) })),
    s("ssec", fmt("\\subsection{{{}}}", { i(1) })),
    s("sssec", fmt("\\subsubsection{{{}}}", { i(1) })),

    -- Textbf, textit, etc
    s("bf", fmt("\\textbf{{{}}}", { i(1) })),
    s("it", fmt("\\textit{{{}}}", { i(1) })),
    s("tt", fmt("\\texttt{{{}}}", { i(1) })),

    -- Cite and ref
    s("cite", fmt("\\cite{{{}}}", { i(1, "key") })),
    s("ref", fmt("\\ref{{{}}}", { i(1, "label") })),

    -- beamer slide environment
    s(
        "frame",
        fmt(
            [[
\begin{{frame}}{{{}}}
    {}
\end{{frame}}
  ]],
            { i(1, "title"), i(2) }
        )
    ),

    s(
        "frame",
        fmt(
            [[
\begin{{center}}
    {}
\end{{center}}
  ]],
            { i(1, "title") }
        )
    ),

    s(
        "columns",
        fmt(
            [[
\begin{{columns}}
    \begin{{column}}{{{}\textwidth}}
      
    \end{{column}}
    \begin{{column}}{{{}\textwidth}}

    \end{{column}}
\end{{columns}}
      ]],
            {
                i(1, "width"),
                i(2, "1 - width"),
            }
        )
    ),

    s(
        "cc",
        fmt(
            [[
{} \copyright {} by Thomas M. Gaul is licensed under CC BY-NC-SA 4.0. To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/
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

    s("vfill", fmt([[\vskip0pt plus 1filll]], {})),

    s("ltex-e", fmt([[% LTeX: enabled=true ]], {})),

    s("ltex-d", fmt([[% LTeX: enabled=false ]], {})),
}
