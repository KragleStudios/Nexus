util.AddNetworkString('nx_layer_set')
util.AddNetworkString("nx_setlayer")

local ENT = FindMetaTable('Entity')

function ENT:setLayer(num)
	ndoc.table.nxLayers[ self:EntIndex() ] = num
end

net.Receive("nx_setlayer", function(l, ply)
	local ent = net.ReadEntity()
	local lay = tonumber(net.ReadString())

	ent:setLayer(lay)
end)
