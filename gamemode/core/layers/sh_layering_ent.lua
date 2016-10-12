local meta = FindMetaTable("Entity")

if (SERVER) then
	function meta:setLayer(int)
		local curLayer = self:getLayer()

		if (not ndoc.table.nxLayers[ int ] and SERVER) then
			nx.layers.createNew(int)
		end

		ndoc.table.nxLayers[ curLayer ].entities[ self:EntIndex() ] = nil
		ndoc.table.nxLayers[ int ].entities[ self:EntIndex() ] = nil
		ndoc.table.nxEntLayers[ self:EntIndex() ] = int

		if (self:IsPlayer()) then
			/*for k,v in pairs(self:getOwnedEntities()) do
				ndoc.table.nxEntLayers[ v:EntIndex() ] = int
			end*/
			for k,v in pairs(self:GetWeapons()) do
				ndoc.table.nxEntLayers[ v:EntIndex() ] = int
			end
		end
	end

	function meta:resetLayer()
		self:setLayer(nx.config.default_layer)
	end

else

	function meta:handleLayering()
		if (not self:shouldLayer()) then return end

		if (self == LocalPlayer()) then
			for k,v in pairs(ents.GetAll()) do
				if (v == LocalPlayer()) then continue end
				
				v:handleLayering()
			end
		end

		if (self:getLayer() ~= LocalPlayer():getLayer()) then
			self:SetNoDraw(true)
			self:DrawShadow(false)
		else
			self:SetNoDraw(false)
			self:DrawShadow(true)
		end
	end
end

function meta:getLayer()
	return ndoc.table.nxEntLayers and ndoc.table.nxEntLayers[ self:EntIndex() ] or nx.config.default_layer
end

function meta:shouldLayer()
	if (self:IsPlayer()) then return true end
	if (self:IsVehicle()) then return true end
	
	local cl = self:GetClass()

	if (string.find(cl, 'weapon_')) then return true end
	if (string.find(cl, 'prop_')) then return true end
end

