nx.config = nx.config or {} -- for now. todo: make into a module

-- where should data get stored
nx.config.dataDir = "nexus_sv_data"

nx.config.sql = {
	host = "db4free.net",
	database = "nexus1234",
	username = "nexus1234u",
	password = "nexus1234",
	module = "mysqloo",
}

nx.config.dataStore = "sql" -- text OR sql

nx.config.data_cacheUpdateInterval = 60 -- SECONDS
nx.config.data_storeUpdateInterval = 60 * 10 -- SECONDS
assert(nx.config.data_storeUpdateInterval > nx.config.data_cacheUpdateInterval, "defeats the point of caching")

nx.config.dropBlacklist = {
	weapon_physgun = true,
	weapon_physcannon = true,
	gmod_tool = true,
	gmod_camera = true,
	weapon_fists = true,
}

-- this is a fairly processing intensive operation. Making it too fast may cause lag. Too slow may cause players to notice.
nx.config.resourceNetworkUpdateInterval = 1 -- seconds

nx.config.doorRespawnTime = 300 -- Amount of time for a door to respawn, seconds

nx.config.zoneCaptureReward = 1 -- how much boost to give faction salaries per zone they have captured on payday

nx.config.policeFaction = FACTION_POLICE -- this is used for commands like /911, this is the faction which gets the notifications