function GM:OnEntityCreated(ent)
	if (ent:GetClass() ~= "worldspawn") then
		ent:SetCustomCollisionCheck(true)
	end

	if (not ent:shouldLayer()) then return end
	
	if (SERVER) then
		ent:setLayer(nx.config.default_layer)
	else
		ent:handleLayering()
	end
end

function GM:ShouldCollide(ent1, ent2)
	if (not IsValid(ent1) or not IsValid(ent2)) then return true end
	
	local c1 = ent1:GetClass()
	local c2 = ent2:GetClass()

	if (c1 == "worldspawn" or c2 == "worldspawn") then return true end
	
	local l1 = ent1:getLayer()
	local l2 = ent2:getLayer()
	if (l1 ~= l2) then return false end

	return true
end