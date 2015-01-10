local meta = {}
meta.__index = meta

function newPanel(name,base)
	return setmetatable({__name = name, __base = base or "DPanel"},meta)
end

function meta:registerPanel()
	vgui.Register(self.__name,self,self.__base)
end

local path = (GM and GM.Path) or GAMEMODE.Path

function NX.LoadVGUI()
	if SERVER then
		for _, x in pairs(file.Find(path..'/vgui/*','GAME')) do
			AddCSLuaFile("vgui/"..x) print('Sent '..x)
		end
	else
		local fil = file.Find("nexus/gamemode/vgui/*", "LUA")
		for k,v in pairs(fil) do
			print(v) 
			include("vgui/"..v)
		end
	end
end

NX.LoadVGUI()