nx.events.rounds = nx.events.rounds or {}

local baseHandle = {}
function baseHandle:shouldPause()
	local plys = nx.events:getPlayers(self.id)

	if (plys < 2) then return true end
end

function baseHandle:pause()
	--freeze players or smth, rounds don't actually continue here
end

function baseHandle:end()
	--show scoreboard and shit
end

function baseHandle:gameOver()
	--show final scoreboard, event over, and do return to main preperation
end

function baseHandle:destroy()
	nx.events:destroyEvent(self.id) --send everyone back

	timer.Destroy("roundHandler."..self.id)
end

function baseHandle:shouldStop()
	local plys = nx.events:getPlayers(self.id)

	if (plys == 0) then return true end
	if (self.data.shouldEnd(self.id)) then return true end
end

function baseHandle:setup()
	self.data.setup(self.id)
end

function baseHandle:update()
	if (self:shouldStop()) then
		self:destroy()
	end

	if (self:shouldPause()) then
		self.old_time_left = self.time_left
		self.old_state = self.state

		self.state = STATE_PAUSED
		self.time_left = 10

	elseif (self.state == STATE_PAUSED)

		self.state = self.old_state
		self.time_left = self.old_time_left

	end
	
	if (self.state ~= STATE_PAUSED) then
		if (self.time_left == 0 and self.state == STATE_RUNNING) then
			self.state = STATE_ENDING
			self.time_left = 10

			self:end()
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
		end
	end


	ndoc.table.nxActiveEvents[ self.id ].rounds_left = self.rounds_left
	ndoc.table.nxActiveEvents[ self.id ].state = self.state
	ndoc.table.nxActiveEvents[ self.id ].time_left = self.time_left
	self.time_left = self.time_left - 1
end

function nx.events.rounds:start(id, gamemode)
	local eventData = nx.eventsList [ gamemode ]

	baseHandle.id = id
	baseHandle.data = eventData
	baseHandle.time_left = 0 --force start
	baseHandle.state = STATE_ENDING --force start
	baseHandle.rounds = eventData.play_style[ 2 ]
	baseHandle.time_limit = eventData.play_style[ 3 ]
	
	local obj = {}
	setmetatable(obj, {
			__index = baseHandle
		})

	timer.Create("roundHandler."..id, 1, 0, obj:update())
end
