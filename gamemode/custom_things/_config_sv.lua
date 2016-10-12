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

nx.config.default_nexi = 10000