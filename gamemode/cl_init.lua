include("shared.lua")
include("libraries.lua")
include("vgui.lua")

function GM:LoadFonts()
	surface.CreateFont('nexus-frame-title',{
		font='default',
		size=22
		})
	surface.CreateFont('nexus-button',{
		font='default',
		size=16
		})
end

function GM:InitPostEntity()
	self:LoadFonts()
end