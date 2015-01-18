hook.Add("PlayerDeath", "PlayerDeath:NexusInitialization", function(vic, inf, att)
	vic.deaths = 0 or vic.deaths + 1
	att.kills  = 0 or att.kills  + 1
end)

hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn:NexusInitialization", function(ply)
	local mdl = ply:GetModel()
	local nexi, events, pac, xp = 0, 0, 0, 0
	local rank = "user" //TODO: Rank system

	NX.MySQL.Query("SELECT * FROM playerdata WHERE steamid =\""..ply:SteamID().."\"", function(query)
		if not query[1] then
			NX.MySQL.Query(([[INSERT INTO playerdata 
				(events_created, events_joined, events_won, events_abandoned, kills, deaths, nexi, model, pac_parts,lastknownposition, rank, xp, steamid) VALUES
				(0, 0, 0, 0, 0, 0, 0, %q, '',%q, 'user', 0, %q)]]):format(mdl,util.TypeToString(ply:GetPos()),ply:SteamID()))

			ply.events_created = 0
			ply.events_joined = 0
			ply.events_won = 0
			ply.events_abandoned = 0
			ply.kills = 0
			ply.deaths = 0
			ply.Nexi = 0
			ply.pac_parts = ''
			ply.rank = "user"
			ply.xp = 0
			ply.lpk = ply:GetPos()
				
		else

			local q = query[1]
			ply.events_created = q["events_created"]
			ply.events_joined = q["events_joined"]
			ply.events_won = q["events_won"]
			ply.events_abandoned = q["events_abandoned"]
			ply.kills = q["kills"]
			ply.deaths = q["deaths"]
			ply.Nexi = q["nexi"]
			ply:SetModel(q["model"])
			ply.pac_parts = q["pac_parts"]
			ply.rank = q["rank"]
			ply.xp = q["xp"]
			ply.lpk = util.StringToType(q["lastknownposition"], "Vector") or ply:GetPos()
		end
	end)
end)

hook.Add("PlayerDisconnected", "PlayerDisconnected:NexusInitialization", function(ply)
	local ev1 = ply.events_created or 0
	local ev2 = ply.events_joined or 0
	local ev3 = ply.events_won or 0
	local ev4 = ply.events_abandoned or 0
	local kills = ply.kills or 0
	local deaths = ply.deaths or 0
	local nexi = ply.Nexi or 0
	local model = ply:GetModel()
	local pac_parts = ""
	local rank = ""
	local xp = ply.exp or 0
	local lkp = ply:GetPos() 
	lkp = util.TypeToString(lkp)

	NX.MySQL.Query(([[UPDATE playerdata SET (
		events_created = %i,
		events_joined = %i,
		events_won = %i,
		events_abandoned = %i,
		kills = %i,
		deaths = %i,
		nexi = "%i,
		model = %q,
		pac_parts = %q,
		rank = %q,
		xp = %i,
		lastknownposition = %q
	) WHERE steamid = %q]]):format(ev1,ev2,ev3,ev4,kills,deaths,nexi,model,pac_parts,rank,xp,lkp,ply:SteamID()))
end)