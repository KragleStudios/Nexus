util.AddNetworkString('nx_layer_set')
util.AddNetworkString("nx_setlayer")

local ENT = FindMetaTable('Entity')

function ENT:setLayer(num)
	//print('Setting layer for ',self,' layer: ',num)

	self.layer = num
	self:SetNWInt("Layer", num)

	net.Start('nx_layer_set')
		net.WriteUInt(self:EntIndex(),32)
		net.WriteUInt(num,8)
	net.Broadcast()
end

net.Receive("nx_setlayer", function(l, ply)
	local ent = net.ReadEntity()
	local lay = tonumber(net.ReadString())

	ent:setLayer(lay)
end)