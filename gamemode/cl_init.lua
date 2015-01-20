include("shared.lua")
include("libraries.lua")
include("vgui.lua")


function GM:LoadFonts()
	surface.CreateFont('nexus-frame-title',{
		font='default',
		size=36
		})
	surface.CreateFont('nexus-frame-nexi',{
		font='default',
		size=26
		})
	surface.CreateFont('nexus-button',{
		font='default',
		size=16
		})
end

function GM:InitPostEntity()
	self:LoadFonts()
end

function GM:HUDPaint()
	draw.RoundedBox(2,ScrW()/2-2,ScrH()/2-2,4,4,color_white)
end

function GM:PlayerLogin()
	LocalPlayer().lgScreen:Remove()
	net.Start('playerLogin')
	net.SendToServer()
end