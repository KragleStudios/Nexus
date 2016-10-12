if (SERVER) then
	AddCSLuaFile()
end

--nx.dep(CLIENT, "fonts")
nx.dep(CLIENT, "ui")
nx.dep(CLIENT, "events")

nx.include_cl "cl_hud.lua"