function nx.layers.createNew(id)
	if (not id) then
		local id = math.random(0, 1000)

		while ndoc.table.nxLayers[id] do
			id = math.random(0, 1000)
		end
	end

	ndoc.table.nxLayers[ id ] = {}
	ndoc.table.nxLayers[ id ].entities = {}

	return ndoc.table.nxLayers[ id ]
end

function nx.layers.destroy(int)
	if (not ndoc.table.nxLayers[ int ]) then return end

	for k,v in ndoc.pairs(ndoc.table.nxLayers[ int ].entities) do
		ndoc.table.nxEntLayers[ k ] = nx.config.default_layer
	end

	ndoc.table.nxLayers[ int ] = nil
end

hook.Add("PlayerInitialSpawn", "SetCustomCollisionCheck", function(ply)
	ply:SetCustomCollisionCheck(true)
end)

util.AddNetworkString("nx_setlayer")
net.Receive("nx_setlayer", function()
	local ent = net.ReadEntity()
	local layer = tonumber(net.ReadString())

	ent:setLayer(layer)
end)