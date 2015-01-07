net.Receive('nx_layer_set',function()
	local index = net.ReadUInt(32)
	local layer = net.ReadUInt(8)
	local ent = Entity(index)
	
	if !IsValid(ent) then return end

	ent.layer = layer
	ent:handleLayring()
	print(ent:GetClass(), "UPDATED", ent.layer)
end)

concommand.Add("nx_setlayer", function(ply, cmd, args)
	local ent = ply:GetEyeTrace().Entity

	if (not ent) then print("NO ENT") return end
		
	net.Start("nx_setlayer")
		net.WriteEntity(ent)
		net.WriteString(args[1])
	net.SendToServer()
end)

concommand.Add("nx_print", function()
	for k,v in pairs(ents.GetAll()) do
		print(v:GetClass(), v:EntIndex(), v:getLayer())
	end
end)

local ENT = FindMetaTable('Entity')

function ENT:handleLayring()
	if !self:shouldLayer() then return end
	
	local lp = LocalPlayer()
	if self == lp then
	
		for _, x in pairs(ents.GetAll()) do
			if x == lp then continue end
			x:handleLayring()
		end
		return
	end

	if (self:IsPlayer()) then
		local w = self:GetWeapons() or {}
		for k,v in pairs(w) do
			if (!IsValid(v)) then continue end
			v.layer = self:getLayer()
			v:handleLayring()
		end
	end


	if self:getLayer() ~= lp:getLayer() then
		self:SetNoDraw(true)
		self:DrawShadow(false)
	else
		self:SetNoDraw(false)
		self:DrawShadow(true)
	end
end