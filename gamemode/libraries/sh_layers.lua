NX.Layer = {}

NX.Layer.Main = 1

--layer meta--
local layer = {}
layer.__index = layer
layers = {}

function NX.Layer.new()
	local t = {info = {}}
	setmetatable(t,layer.index)
	t.key = table.insert(layers,t)
	return t
end

function NX.Layer.destroy(num)
	table.remove(layers, num)
end

function layer:returnToMain()
	for i=1,self.ents do
		self.ents[i]:SetLayer(NX.Layer.Main)
	end
	layers[self.key] = nil
	return self
end

function layer:setType(type)
	self.type = type
	return self
end

function layer:getInfo()
	//return event.getInfo(self.type)
end

--META--
local ENT = FindMetaTable('Entity')

function ENT:getLayer()
	return (self.layer and self.layer > 0 and self.layer) or nil
end

function ENT:shouldLayer()
	print(self:GetClass())
	
	if self:IsPlayer() then return true end
	if self:IsVehicle() then return true end

	local class = self:GetClass()

	if string.find(class,'weapon_') then return true end
	if string.find(class,'prop_') then return true end
	return false
end

--GM--
local GM = GM or GAMEMODE
function GM:OnEntityCreated(ent)
	if !ent:shouldLayer() then return end
	if SERVER then
		ent:setLayer(NX.Layer.Main)
	else
		if (!ent.layer) then ent.layer = ent:GetNWInt("Layer", NX.Layer.Main) end

		ent:handleLayring()
	end

	if (ent:GetClass() != "worldspawn") then 
		ent:SetCustomCollisionCheck(true)
	end

end

function GM:ShouldCollide(eEnt1, eEnt2)
	if (not IsValid(eEnt1) or not IsValid(eEnt2)) then return true end

	local class1 = eEnt1:GetClass()
	local class2 = eEnt2:GetClass()

	if (class1 == "worldspawn" or class2 == "worldspawn") then
		print(class1, class2)
		return true
	end

	local layer1 = eEnt1:GetNWInt("Layer", NX.Layer.Main)
	local layer2 = eEnt2:GetNWInt("Layer", NX.Layer.Main)

	if (layer1 == layer2) then return true end
	return false

end