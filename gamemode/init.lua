AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("libraries.lua")
AddCSLuaFile("vgui.lua")

include("database.lua")
include("shared.lua")
include("vgui.lua")
include("db_config.lua")

util.AddNetworkString('PlayerInitialSpawn')
util.AddNetworkString('playerLogin')

if (!config) then
	print("No valid config installed.")
	return
end

NX.MySQL = {}
NX.MySQL.DB = DB.New(config)
function NX.MySQL.Escape(sQuery)
	return NX.MySQL.DB:Escape(sQuery)
end

function NX.MySQL.Query(sQuery, fCallback)
	return NX.MySQL.DB:Query(sQuery, fCallback)
end

function GM:Initialize()
	NX.MySQL.Query([[
	CREATE TABLE IF NOT EXISTS `playerdata` (
	  `events_created` int(255) unsigned NOT NULL,
	  `events_joined` int(55) unsigned NOT NULL,
	  `events_won` int(255) unsigned NOT NULL,
	  `events_abandoned` int(255) unsigned NOT NULL,
	  `lastknownposition` varchar(255) NOT NULL,
	  `kills` int(255) unsigned NOT NULL,
	  `deaths` int(255) unsigned NOT NULL,
	  `nexi` bigint(255) unsigned NOT NULL,
	  `model` varchar(255) NOT NULL,
	  `pac_parts` mediumtext NOT NULL,
	  `rank` varchar(255) NOT NULL,
	  `xp` bigint(255) unsigned NOT NULL,
	  `steamid` varchar(255) NOT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])
end
function GM:PlayerInitialSpawn(ply)
	ply.loggedIn = false
	timer.Simple(1,function()
		ply:KillSilent()
		ply:SetEyeAngles(Angle(2,145,0))
		ply:SetPos(Vector(120,-52,70))
		net.Start('PlayerInitialSpawn')
		net.Send(ply)
	end) //positions and stuff will change once we have a normal map
end

function GM:PlayerDeathThink(ply)
	return ply.loggedIn
end

include("libraries.lua")

net.Receive('playerLogin',function(_,ply)
	ply.loggedIn = true
	ply:Spawn()
	local pos = ply.lpk or ply:GetPos()
	ply:SetPos(pos)
end)