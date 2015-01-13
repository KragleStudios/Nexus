AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("libraries.lua")
AddCSLuaFile("vgui.lua")
AddCSLuaFile("network.lua")

include("database.lua")
include("shared.lua")
include("libraries.lua")
include("vgui.lua")

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

function GM:PlayerInitialSpawn(ply)
	ply.loggedIn = false
	ply:KillSilent()
	network.new('PlayerInitialSpawn'):send(ply)
end

function GM:PlayerDeathThink(ply)
	return ply.loggedIn
end