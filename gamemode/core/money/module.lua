if (SERVER) then
	AddCSLuaFile()
end

nx.dep(SHARED, "data")

nx.include_sh "sh_money.lua"