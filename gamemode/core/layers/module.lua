if SERVER then
	AddCSLuaFile()
end

-- load internal dependencies
nx.dep(SHARED, "notif")
nx.dep(SERVER, "data")

ndoc.table.nxLayers = ndoc.table.nxLayers or {}

-- load core team system
nx.include_sh "sh_layers.lua"
nx.include_sv "sv_layers.lua"
nx.include_cl "cl_layers.lua"