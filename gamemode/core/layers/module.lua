if SERVER then
	AddCSLuaFile()

	ndoc.table.nxLayers = ndoc.table.nxLayers or {}
	ndoc.table.nxEntLayers = ndoc.table.nxEntLayers or {}
end

nx.layers = nx.layers or {}

-- load internal dependencies
nx.dep(SHARED, "notif")
nx.dep(SERVER, "data")

-- load core team system
nx.include_sh "sh_layering_ent.lua"
nx.include_sv "sv_layering.lua"
nx.include_cl "cl_layering.lua"
nx.include_sh "sh_layering.lua"

if (SERVER) then
	nx.layers.createNew(1)
end