return {
	-- Examples of complete snippets using fmt and fmta
	-- \texttt
	s({ trig = "tt", dscr = "Expands 'tt' into '\texttt{}'" }, fmta("\\texttt{<>}", { i(1) })),
	-- \frac
	s(
		{ trig = "ff", dscr = "Expands 'ff' into '\frac{}{}'" },
		fmt(
			"\\frac{<>}{<>}",
			{
				i(1),
				i(2),
			},
			{ delimiters = "<>" } -- manually specifying angle bracket delimiters
		)
	),
	-- Equation
	s(
		{ trig = "eq", dscr = "Expands 'eq' into an equation environment" },
		fmta(
			[[
         \begin{equation*}
             <>
         \end{equation*}
       ]],
			{ i(0) }
		)
	),
	-- Examples of Greek letter snippets, autotriggered for efficiency
	s({ trig = ";a", snippetType = "autosnippet" }, {
		t("\\alpha"),
	}),
	s({ trig = ";b", snippetType = "autosnippet" }, {
		t("\\beta"),
	}),
	s({ trig = ";g", snippetType = "autosnippet" }, {
		t("\\gamma"),
	}),
	-- Example of a multiline text node
	s({ trig = "lines", dscr = "Demo: a text node with three lines." }, {
		t({ "Line 1", "Line 2", "Line 3" }),
	}),
	-- Code for environment snippet in the above GIF
	s(
		{ trig = "env", snippetType = "autosnippet" },
		fmta(
			[[
        \begin{<>}
            <>
        \end{<>}
      ]],
			{
				i(1),
				i(2),
				rep(1), -- this node repeats insert node i(1)
			}
		)
	),
	-- Example use of insert node placeholder text
	s(
		{ trig = "hr", dscr = "The hyperref package's href{}{} command (for url links)" },
		fmta([[\href{<>}{<>}]], {
			i(1, "url"),
			i(2, "display name"),
		})
	),
}
