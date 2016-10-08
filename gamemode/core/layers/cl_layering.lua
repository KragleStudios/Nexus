ndoc.observe(ndoc.table, 'nx.updateLayersCL', function(index, layer)

	local ent = Entity(index)
	
	if !IsValid(ent) then return end

	ent:handleLayering()

end, ndoc.compilePath('nxEntLayers.?'))

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
