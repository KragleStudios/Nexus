local path = (GM and GM.Path) or GAMEMODE.Path

function NX.LoadLibraries()
	print("Loading Libraries!")
	if (SERVER) then
		for _, x in pairs(file.Find(path..'/libraries/*','GAME')) do

			local realm = x:sub(1,2)
			if realm == 'cl' then
				AddCSLuaFile("libraries/"..x) print('Sent '..x)
			elseif realm == 'sv' then
				include("libraries/"..x) print('Included '..x)
			elseif realm =='sh' then
				AddCSLuaFile("libraries/"..x) print('Sent '..x)
				include("libraries/"..x)
			end
		end
	else
		local fil = file.Find("nexus/gamemode/libraries/*", "LUA") //blah blah use this instead of path. path includes the gamemodes folder
		for k,v in pairs(fil) do

			print(v) 
			include("libraries/"..v)
		end
	end
end

NX.LoadLibraries()