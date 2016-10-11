STATE_PAUSED  = 1
STATE_SETUP   = 4
STATE_RUNNING = 2
STATE_ENDING  = 3

STYLE_ROUNDS = 1
STYLE_TIMED  = 2

function nx.events:register(data)
	assert(data.name, 'events must have names!')
	assert(data.locations, 'events must contain location data!')
	assert(data.restrictions, 'events must have restrictions!')

	if (data.round_based and data.rounds and data.time_limit) then
		data.play_style = {STYLE_ROUNDS, data.rounds, data.time_limit}
	elseif (data.time_limit) then
		data.play_style = {STYLE_TIMED}
	else
		error('you fucked up bro')
	end

	nx.eventsList[ data.name ] = data -- this stores all function data and stuff
	ndoc.table.nxEvents[ data.name ] = { --this stores things relevant to the client only
		locations = data.locations,
		restrictions = data.restrictions,
		play_style = data.play_style
	}
end

function nx.events:canJoin(ply, ev_id)

end

function nx.events:getPlayers(ev_id)
	local ndocPlys = ndoc.table.nxActiveEvents[ ev_id ].players
	local plys = {}

	for k,v in ndoc.pairs(ndocPlys) do
		table.insert(plys, v)
	end

	return plys
end

function nx.events:joinEvent(ply, ev_id)
	local eventData = ndoc.table.nxActiveEvents[ ev_id ]

	if (not eventData) then return end
	if (not nx.events:canJoin(ply, ev_id)) then return end

	if (eventData.state == STATE_ENDING or eventData.state == STATE_RUNNING) then
		ndoc.table.nxActiveEvents[ ev_id ].spectators[ ply ] = true
	else
		ndoc.table.nxActiveEvents[ ev_id ].players[ ply ] = true
	end

	ply:setLayer(eventData.layer)

	local event_Functions = nx.eventsList[ eventData.gamemode ]
	event_Functions:playerJoinEvent(ply, ev_id)
end

function nx.events:leaveEvent(ply, ev_id)
	local eventData = ndoc.table.nxActiveEvents[ ev_id ]
	if (not eventData) then return end
	
	ndoc.table.nxActiveEvents[ ev_id ].spectators[ ply ] = nil
	ndoc.table.nxActiveEvents[ ev_id ].players[ ply ] = nil

	ply:resetLayer()

	local event_Functions = nx.eventsList[ eventData.gamemode ]
	event_Functions:playerLeftEvent(ply, ev_id)

	local shouldPause = event_Functions:shouldPause(ev_id)

	if (shouldPause) then event_Functions:doPause(ev_id) end
end

function nx.events:destroyEvent(id, data)
	for k,v in ndoc.pairs(ndoc.table.nxActiveEvents[ ev_id ].players) do
		if (not IsValid(k)) then continue end

		k:resetLayer()
	end
	for k,v in ndoc.pairs(ndoc.table.nxActiveEvents[ id ].spectators) do
		if (not IsValid(k)) then continue end

		k:resetLayer()
	end


	for hk,v in pairs(data.hooks) do
		hook.Remove(hk, hk..id)
	end

	ndoc.table.nxActiveEvents[ id ] = nil

	--do some notification of shit
end

function nx.events:sendInvite(players, ev_id)
	
end

function nx.events:new(type, name, creator, private, invitations, locationID)
	local id = math.random(0, 1000)
	local ev_data = nx.eventsList[ type ]

	while ndoc.table.nxActiveEvents[ id ] do
		id = math.random(0, 1000)
	end

	--No event with that gamemode name was found
	if (ev_data) then return end
	if (not name or not creator or private == nil or not invitations or not locationID) then return end
	
	local rest = ev_data.restrictions
	local maxPlayers = rest.MaxPlayers
	local playTime = rest.MaxPlayTime
	local location = ev_data.locations[ locationID ]
	local maxRounds = ev_data.MaxRounds
	local maxScore  = ev_data.MaxScore

	local layer = nx.layers.createNew()

	ndoc.table.nxActiveEvents[ id ] = {
		layer = layer,
		maxplayers = maxPlayers,
		playtime = playTime,
		loc = location,
		maxrounds = maxRounds,
		maxscore = maxScore,
		private = private,
		creator = creator,
		gamemode = type,
		event_name = name,
		players = {},
		spectators = {},
		state = STATE_PAUSED
	}

	for k,v in pairs(invitations) do
		nx.events:sendInvite(v, id)
	end

	nx.events:joinEvent(creator)

	hook.Add("Think", "Hook_ShouldStart_"..id, function()
		if (not ndoc.table.nxActiveEvents[ id ]) then 
			hook.Remove("Think", "Hook_ShouldStart_"..id)
			return
		end

		if (nx.eventsList[ type ].shouldPlay(id)) then
			local playStyle = ev_data.play_style[1]

			if (playStyle == STYLE_ROUNDS) then
				nx.events.rounds:start(id, type) --new round based event
			else
				nx.events.timed:start(id, type) --new timed based event
			end
		end
	end)

	for hk, cback in pairs(ev_data.hooks) do
		hook.Add(hk, hk .. id, function(...)
			local players_in_event = nx.events:getPlayers(id)

			for k,v in pairs({...}) do
				if (type(v) == "player" and not table.HasValue(players_in_event, v)) then continue end --this will continue everytime a hook has a player entity not in our specific event

				cback(...)
			end
		end)
	end
end

