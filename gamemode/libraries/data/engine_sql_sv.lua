require "ezdb"

local engine = {database = ezdb.create(nx.config.sql)}

function engine.database:onConnected()
	nx.print("Conneced to the database")

	self:create("nx_playerdata")
		:create("id", "INTEGER NOT NULL AUTO_INCREMENT")
		:create("data", "BLOB")
		:create("events_created", "int(255)  NOT NULL")
		:create("events_joined", "int(55)  NOT NULL")
		:create("events_won", "int(255)  NOT NULL")
		:create("events_abandoned", "int(255)  NOT NULL")
		:create("lastknownposition", "varchar(255) NOT NULL")
		:create("kills", "int(255)  NOT NULL")
		:create("deaths", "int(255)  NOT NULL")
		:create("nexi", "int(255)  NOT NULL")
		:create("model", "varchar(255) NOT NULL")
		:create("pac_parts", "mediumtext NOT NULL")
		:create("rank", "varchar(255) NOT NULL")
		:create("xp", "bigint  NOT NULL")
		:create("steamid", "varchar(255) NOT NULL")
		:primaryKey("id")
	:execute()
end

function engine.database:onConnectionFailed(err)
	nx.print(err)
end

engine.loadPlayerData = function(steamid64, callback)
	engine.database:select("nx_playerdata"):where("steamid", steamid64):execute(function(result)
		if (#result == 1) then
			callback(result)
		else
			engine.database:insert("nx_playerdata")
				:insert("steamid", steamid64)
				:insert("nexi", 0)
				:insert("events_created", 0)
				:insert("events_joined", 0)
				:insert("events_won", 0)
				:insert("events_abandoned", 0)
				:insert("lastknownposition", "")
				:insert("kills", 0)
				:insert("deaths", 0)
				:insert("model", "")
				:insert("pac_parts", "")
				:insert("rank", "user")
				:insert("xp", 0)
				:where("steamid", steamid64)
			:execute(function() ErrorNoHalt("TEST") end)
		end
	end)
end

engine.updatePlayerData = function(steamid64, data, callback)
	engine.database:select("nx_playerdata"):where("steamid", steamid64):execute(function(result)
		if (#result == 1) then
			engine.database:update("nx_playerdata")
				:update("nexi", data.nexi)
				:update("events_created", data.events_created)
				:update("events_joined", data.events_joined)
				:update("events_won", data.events_won)
				:update("events_abandoned", data.events_abandoned)
				:update("lastknownposition", data.last_known_position)
				:update("kills", data.kills)
				:update("deaths", data.deaths)
				:update("model", data.model)
				:update("pac_parts", data.pac_parts)
				:update("rank", data.rank)
				:update("xp", data.xp)
				:where("steamid", steamid64)
			:execute(callback)
		else
			engine.database:insert("nx_playerdata")
				:insert("steamid", steamid64)
				:insert("nexi", 0)
				:insert("events_created", 0)
				:insert("events_joined", 0)
				:insert("events_won", 0)
				:insert("events_abandoned", 0)
				:insert("lastknownposition", "")
				:insert("kills", 0)
				:insert("deaths", 0)
				:insert("model", "")
				:insert("pac_parts", "")
				:insert("rank", "user")
				:insert("xp", 0)
				:where("steamid", steamid64)
			:execute(callback)
		end
	end)
end

return engine
