nx.data = nx.data or {}
local data = nx.data

-- load external dependencies
require "spon" spon.noCompat = true

-- create directories
data._rootdir = nx.config.dataDir
data._cacheFile = data._rootdir .. "/sessionCache.txt"
file.CreateDir(data._rootdir)

local engine = include "engine_sql_sv.lua"
engine.database:connect()

--
-- CREATE PLAYER DATA TABLE
--

-- fields to persist
data.persistFields = {}

local function updateStorage(tbl, val, a, b, ...)
	if b == nil then
		tbl[a] = val
		return
	end
	if not tbl[a] then
		tbl[a] = {}
	end
	updateStorage(tbl[a], val, b, ...)
end

local fields = {}

function data.addPersistField(field)
	ndoc.observe(ndoc.table, "nx.persistField", function(pl, value)
		local pl = Entity(pl)

		if not data.player[pl] then return end
		data.player[pl][field] = value
	end, "nxPData", ndoc.kWILDCARD, field)

end


-- player data table
data.player = {}

function data.loadPlayer(player)
	nx.print("loading data for " .. tostring(player).. ".")

	data.player[player] = data.player[player] or {}

	if not ndoc.table.nxPData[player:EntIndex()] then
		ndoc.table.nxPData[player:EntIndex()] = {}
	end
	engine.loadPlayerData(player:SteamID64() or "0", function(_data)
		-- copy the data to data.player
		data.player[player] = _data

		-- copy it into the net table
		local pdataTable = player:GetData()
		for k,v in pairs(_data) do
			pdataTable[k] = v
		end

		hook.Call("NXLoadedPlayerData", player)
	end)
end

function data.updateStore(player)
	nx.print("update store for " .. tostring(player))
	if not data.player[player] then
		nx.hud.pushNotification(ply, "Error",  "Your account data is currently loaded in offline mode. Your progress will not save. Please reconnect.", Color(255, 0, 0))
		return
	end

	local dataTable = ndoc.table.nxPData[player:EntIndex()]
	dataTable.last_known_position = tostring(player:GetPos())
	dataTable.kills = (dataTable.kills or 0) + player:Frags()
	dataTable.deaths = (dataTable.deaths or 0) + player:Deaths()
	dataTable.model = player:GetModel()
	dataTable.pac_parts = ""

	engine.updatePlayerData(player:SteamID64() or "0", dataTable, ra.fn.noop) -- no callback
end

--
-- HOOKS TO LOAD AND STORE PLAYER SESSION DATA
--
hook.Add("PlayerInitialSpawn", "LoadPlayer", function(pl)
	data.loadPlayer(pl)
end)

hook.Add("PlayerDisconnected", "SavePlayer", function(pl)
	data.updateStore(pl)

	data.player[pl] = nil
	ndoc.table.nxPData[pl] = nil
end)

hook.Add("ShutDown", "UpdateSHutdown", function()
	data.updateGlobalCache()
end)

--
-- SAVE ALL PLAYER DATA TO A SESSION CACHE
--
function data.updateGlobalCache()
	local persist = {}
	for player, data in pairs(data.player) do
		persist[player:SteamID64() or "0"] = data
	end

	file.Write(data._cacheFile, spon.encode(persist))
end

timer.Create("fwUpdateCache", nx.config.data_cacheUpdateInterval, 0, function()
	data.updateGlobalCache()
end)

timer.Create("fwUpdateStore", nx.config.data_storeUpdateInterval, 0, function()
	for k, player in ipairs(player.GetAll()) do
		data.updateStore(player)
	end
end)

--
-- restore sessions from the cache to the perminant data store
--
/*
if file.Exists(data._cacheFile, "DATA") then
	local succ, sessionCache = pcall(spon.decode, file.Read(data._cacheFile, "DATA"))
	if not succ then
		nx.print("failed to recover player data session cache!")
		nx.print(sessionCache)
	else

		for steamid64, sessionData in pairs(sessionCache) do
			nx.print("recovered session data for player " .. steamid64)

			-- if the player is somehow online then force them to reload their data
			engine.updatePlayerData(steamid64, sessionData, function()
				for k,v in pairs(player.GetAll()) do
					if v:SteamID64() == steamid64 then
						data.loadPlayer(v)
					end
				end
			end)
		end

	end
end
*/
--
-- some lua refresh compatability
--
for k,v in ipairs(player.GetAll()) do
	data.loadPlayer(v)
end
--
-- CONSOLE COMMANDS
--
concommand.Add("fw_data_updateStore", function(pl, cmd, args)
	if IsValid(pl) and not pl:IsSuperAdmin() then pl:ChatPrint("insufficient privliages") return end

	if IsValid(pl) then
		pl:FWConPrint("updated data store for all players")
	else
		nx.print("updated data store for all players")
	end

	for k,v in pairs(player.GetAll()) do
		data.updateStore(v)
	end
end, function()
	return {"commits all changes to player data to the long term storage"}
end)

concommand.Add("fw_data_updateCache", function(pl, cmd, args)
	if IsValid(pl) and not pl:IsSuperAdmin() then pl:ChatPrint("insufficient privliages") return end

	if IsValid(pl) then
		pl:FWConPrint("updated global cache")
	else
		nx.print("updated global cache")
	end

	data.updateGlobalCache()
end, function()
	return {"updates the local value cache, this is for crash tolerance"}
end)
