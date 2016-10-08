--
-- DEFINES FONTS TO BE USED THROUGHOUT THE GAMEMODE
--

if SERVER then
	AddCSLuaFile()
	return
end

require "sty"

nx.fonts = {}

nx.fonts.default = sty.Font {
	font = "Roboto",
	weight = 100
}

nx.fonts.default_shadow = sty.Font {
	font = "Roboto",
	weight = 100,
	shadow = true
}

nx.fonts.default_compact = sty.Font {
	font = "Roboto Condensed",
	weight = 100
}

nx.fonts.default_compact_shadow = sty.Font {
	font = "Roboto Condensed",
	weight = 100,
	shadow = true
}

nx.fonts.default_bold = sty.Font {
	font = "Roboto Bold",
	weight = 100,
}
