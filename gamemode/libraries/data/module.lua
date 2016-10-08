if SERVER then AddCSLuaFile() end

nx.dep(SHARED, "notif")

file.CreateDir(nx.config.dataDir)

local Player = FindMetaTable("Player")


if SERVER then
	ndoc.table.nxPData = {}

	local playerData = ndoc.table.nxPData

	function Player:GetData()
		return playerData[self:EntIndex()]
	end
else
	local playerData = {}
	ndoc.observe(ndoc.table, 'wait for nxPData', function()
		playerData = ndoc.table.nxPData or {}
	end, ndoc.compilePath('nxPData'))

	local noData = setmetatable({}, {__newindex = function(self, key) rawset(self, key, nil) end})

	function Player:GetData()
		return playerData[self:EntIndex()] or noData
	end

end

nx.include_sv "data_sv.lua"
