local EV = {}
EV.name = 'Player vs Player'
EV.locations = {
	['Grass 1'] = 1,
	['Grass 2'] = 2
}

EV.round_based = false -- is this round based?
EV.rounds = 0 --how many rounds if so?
EV.time_limit = 120 -- how long should an event last?

EV.restrictions = {
	maxPlayers = 10, --what's the max allowed to join?
	minPlayers = 2
}

EV.kills = 10

EV.hooks = {

	--Handles player death for our stuff. Note: this auto checks to make sure the players are in this event.
	['DoPlayerDeath'] = function(ply, attacker, dmgInfo, event)
		event.cache[ ply ] = event.cache[ ply ] or {}
		event.cache[ attacker ] = event.cache[ attacker ] or {}

		event.cache[ ply ].deaths = event.cache[ ply ].deaths and event.cache[ ply ].deaths + 1 or 0
		event.cache[ attacker ].kills = event.cache[ attacker ].kills and event.cache[ attacker ].kills + 1 or 0
	
		if (event.cache[ attacker ].kills == EV.kills) then
			event.max_kills = event.cache[ attacker ].kills
		end
	end, 
}

--return whether or not the max kills has been reached
function EV.shouldEnd(event)
	return event.max_kills
end

--what we do when we decide we need to end
function EV.doPause(event)
	for k,v in pairs(event.players) do
		v:Freeze(true)
	end
end

--should the game be put into the paused state?
--NOTE: The server automatically checks players against the minimum required
function EV.shouldPause(event)
	return false
end

--what we do when we decide the game is over
function EV.doGameOver(event)
	for k,v in pairs(event.players) do
		v:Freeze(false)
	end
end

--who won the game!!
function EV.getWinner(event)
	return event.max_kills
end

--can our player join the event????
function EV.canJoinEvent(event, player)
	return true
end

--we joined so what
function EV.playerJoinEvent(event, player)
	player:Give("weapon_ar2")
end


--we left cuz we are a bitch
--NOTE: This gets called on all active players when an event is destroyed too!
function EV.playerLeftEvent(event, player)
	player:StripWeapon("weapon_ar2")
end

nx.events:register(EV)


--THE FOLLOWING COMMANDS ARE FOR ROUND BASED GAMEMODES ONLY!
--Called everytime a new round is in the setup state
function EV.doRoundSetup(event)

end

--Called everytime a round is in the ending phase
function EV.doRoundEnd(event)

end

--Called everytime a new round StartSchedule
function EV.doRoundStart(event)

end