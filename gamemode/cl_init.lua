include("shared.lua")
include("libraries.lua")
include("vgui.lua")

NX = NX or {}

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

function GM:PlayerBindPress( ply, bind, pressed )
	if string.find(bind,"undo") then 
		ply.cursorOn = !ply.cursorOn
		gui.EnableScreenClicker(ply.cursorOn)
		for _, pnl in pairs(NX.minimizedFrames) do
			if !IsValid(pnl) then return end
			pnl:SetMouseInputEnabled(ply.cursorOn)
		end
	end
end

concommand.Add('gen_ui',function(ply,cmd,args)
	local f = vgui.Create('NFrame')
	local b = vgui.Create('NButton',f)
	b:SetPos(f:GetWide()/2-b:GetWide()/2,f:GetTall()-b:GetTall()-50)
end)
