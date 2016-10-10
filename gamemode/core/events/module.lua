if SERVER then
	AddCSLuaFile()

	nx.events = nx.events or {} --unsycned table of event data
	ndoc.table.nxEvents = ndoc.table.nxEvents or {} --synced table of event data
	ndoc.table.nxActiveEvents = ndoc.table.nxActiveEvents or {}
end

-- load internal dependencies
nx.dep(SHARED, "notif")
nx.dep(SERVER, "data")

-- load core team system
/*
nx.include_sh "sh_events.lua"
nx.include_sv "sv_events.lua"
nx.include_sv "sv_rounds.lua"
nx.include_sv "sv_timed.lua"
nx.include_cl "cl_events.lua"*/