local path = (GM and GM.Path) or GAMEMODE.Path

nx.Events = nx.Events or {}
nx.Events.List = nx.Events.List or {}
nx.Events.ActiveEvents = nx.Events.ActiveEvents or {}

function nx.Events:Register(sName, tEventData)
	nx.Events.List[sName] = {
		restrictions = tEventData.restrictions;
		settings     = tEventData.default_settings;
		event        = tEventData;
		locations    = tEventData.locations;
		hooks 		 = tEventData.hooks;
	}
end

function nx.Events:Error(pTarget, ...)
	print(tostring({...}))
end

function nx.Events:SendInvite(pPlayer, sName, sGamemode, pInviter, bInvitedByCreator)

end

function nx.Events:JoinEvent(sName, sGamemode, pJoiner)
	local event = nx.Events.ActiveEvents[sName]
	if (not event) then self:Error(pJoiner, "This event is not currently active!") return end 

	local canjoin, cantreason = event.event:CanPlayerJoin(pJoiner, self:GetInfo(sName))
	if (canjoin) then
		nx.Events.ActiveEvents[sName].Players = nx.Event.ActiveEvents[sName].Players + 1
		pJoiner:setLayer(event.LayerID)
	else
		self:Error(pJoiner, "You can't join this event because ", cantreason)
	end
end

function nx.Events:LeaveEvent(sName, pLeaver)
	nx.Events.ActiveEvents[sName].Players = nx.Event.ActiveEvents[sName].Players - 1

	pLeaver:setLayer(nx.Layer.Main)
end

function nx.Events:GetInfo(sName)
	return self.ActiveEvents[sName]
end

function nx.Events:CreateEvent(sGamemode, sName, pCreator, iMaxPlayers, iPlayTime, iMaxRounds, iMaxScore, bPrivate, tInvitations, iLocationID)
	local event = nx.Events.List[sGamemode]
	if (not event) then self:Error(pCreator, "Gamemode not found! Yours ", sGamemode) return end 

	local ev_hooks = {}
	for i=0, #event.hooks do
		local hname = i..layer.key..sName
		local realm = event.hooks[i][2]

		if (SERVER and realm == "Server") then
			hook.Add(i, hname, event.hooks[i].call)
		elseif (CLIENT and realm == "Client") then 
			hook.Add(i, hname, event.hooks[i].call)
		else
			hook.Add(i, hname, event.hooks[i].call)
		end

		ev_hooks[i] = {hname, realm}
	end

	if (CLIENT) then return end

	local def = event.settings
	if (def) then
		if (def.maxplayers and not iMaxPlayers) then iMaxPlayers = def.maxplayers end
		if (def.maxplaytime and not iPlayTime) then iPlayTime = def.maxplaytime end
		if (def.location and not iLocationID) then iLocationID = def.location end
		if (def.maxrounds and not iMaxRounds) then iMaxRounds = def.maxrounds end
		if (def.maxscore and not iMaxScore) then iMaxScore = def.maxscore end
		if (def.private and not bPrivate) then bPrivate = def.private end

		if (not sName) then sName = sGamemode end
	end

	local restrictions = event.restrictions
	if (restrictions) then
		if (restrictions.maxplayers and iMaxPlayers and iMaxPlayers > restrictions.maxplayers) then 
			iMaxPlayers = restrictions.maxplayers
		end

		if (restrictions.maxplaytime and iPlayTime and iPlayTime > restrictions.maxplaytime) then
			iPlayTime = restricitons.maxplaytime
		end

		if (restrictions.maxrounds and iMaxRounds and iMaxRounds > restrictions.maxrounds) then
			iMaxRounds = restrictions.maxrounds
		end

		if (restrictions.maxscore and iMaxScore and iMaxScore > restrictions.maxscore) then
			iMaxScore = restrictions.maxscore
		end
	end

	if (#tInvitations > 0) then
		for i=0, #tInvitations do
			local targ = Entity(tInvitations[i])
			if (!IsValid(targ) or not targ:IsPlayer()) then nx.Events:Error(pCreator, "Unable to invite player of index: ", tInvitations[i]) continue end
			
			nx.Events:SendInvite(targ, sName, sGamemode, pCreator, false)
		end
	else
		local players = player.GetAll()
		for i=0, #players do
			nx.Events:SendInvite(players[i], sName, sGamemode, pCreator, true)
		end
	end

	local layer = nx.Layer.New

	if (SERVER) then
		pCreator:setLayer(layer.key)
	end
	pCreator.layer = layer.key

	nx.Events.ActiveEvents[sName] = {
		Players = 1;
		Type = sGamemode;
		Private = bPrivate;
		Creator = pCreator;
		Location = iLocationID;
		MaxPlayers = iMaxPlayers;
		Layer = layer;
		LayerID = layer.key;
	}

	

	local ev_funcs = event.event
	local function evLogic()

		hook.Add("Think", "Think:"..layer, function()
			if (self:GetInfo(sName).Players >= 2 and ev_funcs:ShouldStart(self:GetInfo(sName)) and not ev_funcs:IsRunning()) then
				ev_funcs:Start(self:GetInfo(sName))
			end
			if (self:GetInfo(sName).Players < 2) then
				ev_funcs:Pause(self:GetInfo(sName))
				hook.Remove("Think", "Think:"..layer)

				local c = 0
				timer.Create("Timer:"..layer, 0.1, 2100.1, function()
					c = c + 0.1
					if (c == 2100) then 
						ev_funcs:Kill(self:GetInfo(sName))
						layer:returnToMain()

						for i=0, #ev_hooks do
							hook.Remove(i, ev_hooks[i])
						end
					else
						ev_funcs:Continue(self:GetInfo(sName))
						evLogic()
						timer.Destroy("Timer:"..layer)
					end
				end)
			end
			if (ev_funcs:ShouldEnd(self:GetInfo(sName))) then
				ev_funcs:EndPretty(self:GetInfo(sName))
				layer:returnToMain()
			end
		end)

	end
end

function nx.LoadEvents()
	print("Loading Events!")
	if (SERVER) then
		for _, x in pairs(file.Find(path..'/events/*','GAME')) do

			print(x)
			local realm = x:sub(1,2)
			if realm == 'cl' then
				AddCSLuaFile("../events/"..x) print('Sent '..x)
			elseif realm == 'sv' then
				include("../events/"..x) print('Included '..x)
			elseif realm =='sh' then
				AddCSLuaFile("../events/"..x) print('Sent '..x)
				include("../events/"..x)
			end
		end
	else
		local fil = file.Find("nexus/gamemode/events/*", "LUA")
		for k,v in pairs(fil) do

			print(v) 
			include("events/"..v)
		end
	end
end

nx.LoadEvents()

local meta = FindMetaTable("Player")

if (SERVER) then
	function meta:addPoints(num)
		self.points = self.points + num
		self:SetNWInt("Points", self.points)
	end

	function meta:takePoints(num)
		self.points = self.points - num
		self:SetNWInt("Points", self.points)
	end
end

function meta:getPoints()
	if (self.points != self:GetNWInt("Points", 0)) then
		self.points = self:GetNWInt("Points", 0)
	end

	return self.points
end
