nx.events.rounds = nx.events.rounds or {}

local roundHandler = {}
function roundHandler:shouldPause()
	if (self.data.shouldPause(self)) then return true end
	if (#self.players < (self.data.restrictions.minPlayers or 2)) then return true end
end

function roundHandler:pause()
	self.data.doPause(self)
end

function roundHandler:finish()
	self.data.rewardWinner(self.data.getWinner(self))

	local data = self.data.getScoreboardPop(self)
	nx.events:showScoreboard(self, data)
	
	self.data.doRoundEnd(self)
end

function roundHandler:gameOver()
	--show final scoreboard, event over, and do return to main preperation

	self.data.rewardWinner(self.data.getWinner(self))

	local data = self.data.getScoreboardPop(self)
	nx.events:showScoreboard(self, data)
	
	self.data.doGameOver(self)

	timer.Simple(10, function()
		self:destroy()
	end)
end

function roundHandler:destroy()
	nx.events:destroyEvent(self.id, self.data) --send everyone back

	timer.Destroy("roundHandler."..self.id)
end

function roundHandler:shouldStop()
	if (#self.players == 0) then return true end
	if (self.data.shouldEnd(self)) then return true end
end

function roundHandler:setup()
	local plys = ndoc.table.nxActiveEvents

	for k,v in ndoc.pairs(plys.spectators) do --repopulate the players with these mf late joining bitches

		ndoc.table.nxActiveEvents[ self.id ].players[ k ] = true
		ndoc.table.nxActiveEvents[ self.id ].spectators[ k ] = nil

	end
	
	local spawn_loc = table.Random(self.spawn_locations)
	ply:SetPos(spawn_loc[ 1 ])
	ply:SetAngles(spawn_loc[ 2 ])

	self.data.doRoundSetup(self, self.players)
end

function roundHandler:start()
	self.data.doRoundStart(self)
end

function roundHandler:update()
	self.players = nx.events:getPlayers(self.id)

	if (self:shouldStop()) then
		self:destroy()
		return
	end

	if (self:shouldPause()) then
		self.old_time_left = self.time_left
		self.old_state = self.state

		self.state = STATE_PAUSED
		self.time_left = 10
		self:pause()

	elseif (self.state == STATE_PAUSED) then

		self.state = self.old_state
		self.time_left = self.old_time_left

	end
	
	if (self.state ~= STATE_PAUSED) then
		if (self.time_left == 0 and self.state == STATE_RUNNING) then
			self.state = STATE_ENDING
			self.time_left = 10

			self:finish()
		elseif (self.time_left == 0 and self.state == STATE_ENDING) then
			
			if (self.rounds_left == 0) then
				self:gameOver()
				return
			end

			self.rounds_left = self.rounds_left - 1
			self.state = STATE_SETUP
			self.time_left = 5
			self:setup()

		elseif (self.time_left == 0 and self.state == STATE_SETUP) then
			self.state = RUNNING
			self.time_left = self.time_limit

			self:start()
		end
	else
		if (self.time_left == 0) then
			self:destroy()
			return
		end
	end


	ndoc.table.nxActiveEvents[ self.id ].rounds_left = self.rounds_left
	ndoc.table.nxActiveEvents[ self.id ].state = self.state
	ndoc.table.nxActiveEvents[ self.id ].time_left = self.time_left
	self.time_left = self.time_left - 1
end

function roundHandler:doPlayerJoin(ply)
	local event_Functions = nx.eventsList[ self.data.gamemode ]
	event_Functions:playerJoinEvent(self, ply)
end


function nx.events.rounds:start(id, gamemode)
	local eventData = nx.eventsList [ gamemode ]

	roundHandler.id = id
	roundHandler.data = eventData
	roundHandler.time_left = 0 --force start
	roundHandler.state = STATE_ENDING --force start
	roundHandler.rounds = eventData.play_style[ 2 ]
	roundHandler.time_limit = eventData.play_style[ 3 ]
	roundHandler.cache = {}
	
	local obj = {}
	setmetatable(obj, {
			__index = roundHandler
		})

	timer.Create("roundHandler."..id, 1, 0, obj:update())

	return obj
end
