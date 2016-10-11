nx.events.timed = nx.events.timed or {}

local timedHandler = {}
function timedHandler:shouldPause()
	if (self.data.shouldPause(self)) then return true end

	if (#self.players < (self.data.restrictions.minPlayers or 2)) then return true end
end

function timedHandler:pause()
	self.data.doPause(self)
end

function timedHandler:gameOver()
	--show final scoreboard, event over, and do return to main preperation

	self.data.doGameOver(self)

	timer.Simple(10, function()
		self:destroy()
	end)
end

function timedHandler:destroy()
	nx.events:destroyEvent(self.id, self.data) --send everyone back

	timer.Destroy("nx.timer."..self.id)
end

function timedHandler:shouldStop()
	if (#self.players == 0) then return true end
	if (self.data.shouldEnd(self)) then return true end
end

function timedHandler:update()
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

	elseif (self.state == STATE_PAUSED)

		self.state = self.old_state
		self.time_left = self.old_time_left

	end
	
	if (self.time_left == 0) then
		self:gameOver()
	end

	ndoc.table.nxActiveEvents[ self.id ].state = self.state
	ndoc.table.nxActiveEvents[ self.id ].time_left = self.time_left
	self.time_left = self.time_left - 1
end

function nx.events.timed:start(id, gamemode)
	local eventData = nx.eventsList [ gamemode ]

	timedHandler.id = id
	timedHandler.data = eventData
	timedHandler.time_left = 0 --force start
	timedHandler.state = STATE_PAUSED --force start
	timedHandler.rounds = eventData.play_style[ 2 ]
	timedHandler.time_limit = eventData.play_style[ 3 ]
	timedHandler.cache = {}
	
	local obj = {}
	setmetatable(obj, {
			__index = timedHandler
		})

	timer.Create("nx.timer."..id, 1, 0, obj:update())

	return obj
end
