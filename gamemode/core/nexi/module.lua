if SERVER then
	AddCSLuaFile()
end

-- load internal dependencies
nx.dep(SHARED, "notif")
nx.dep(SERVER, "data")

-- load core team system
nx.include_sh "sh_nexi.lua"