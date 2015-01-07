AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("libraries.lua")

include("database.lua")
include("shared.lua")
include("libraries.lua")

local config = {
	Host = "";
	User = "";
	Pass = "";
	Name = "Nexus";
}

NX.MySQL = {}
/*NX.MySQL.DB = DB.New(config)
function NX.MySQL.Escape(sQuery)
	return NX.MySQL.DB:Escape(sQuery)
end

function NX.MySQL.Query(sQuery, fCallback)
	return NX.MySQL.DB:Query(sQuery, fCallback)
end*/