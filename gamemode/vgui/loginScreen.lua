local pnl = newPanel('LoginScreen','DPanel')
local matBlurScreen = Material( "pp/blurscreen" )

--[[
to do:
make model actual model of player involvin pac and etc
just waiting for you lazy asses to do the database
]]

local function formatNumber(n)
	if (!n) then
		return 0
	end
	if n >= 1e14 then return tostring(n) end
    n = tostring(n)
    sep = sep or ","
    local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
    end
    return n
end

function pnl:Init()
	self:SetSize(ScrW(),ScrH())
	self.model = ClientsideModel('models/player/group02/male_06.mdl')
	self.model:SetPos(Vector(0,0,0))
	self.model:SetSequence(self.model:LookupSequence('walk_all'))

	self.av = vgui.Create('NAvatar')
	self.av:SetPaintedManually(true)
	self.name = vgui.Create('NFrame')
	self.name:SetPaintedManually(true)

	local str = LocalPlayer():Nick()
	surface.SetFont('nexus-frame-title')
	local w,h = surface.GetTextSize(str)

	local nexi = LocalPlayer():getNexi()
	nexi = formatNumber(nexi)..' Nexi'
	surface.SetFont('nexus-frame-title')
	local nw,nh = surface.GetTextSize(nexi)

	self.name:SetSize(50+math.max(nw,w),self.av:GetTall())
	self.name:SetPos(self.av.x+self.av:GetWide()+20,0)
	self.name.Title = str
	self.name.PaintOver = function(self,pw,ph)
		draw.SimpleText(nexi,'nexus-frame-nexi',pw/2,ph-15,Color(152,152,152),1,1)
	end

	self.login = vgui.Create('NButton')
	self.login:SetSize(self.av:GetWide()+self.name:GetWide()+20,50)
	self.login:SetPos(self.av.x,self.av.y+self.av:GetTall()+10)
	self.login:SetText('Login')
	self.login:SetFont('nexus-frame-title')
	self.login:SetPaintedManually(true)

	self.disconnect = vgui.Create('NButton')
	self.disconnect:SetSize(self.login:GetWide(),50)
	self.disconnect:SetPos(self.av.x,self.login.y+self.login:GetTall()+10)
	self.disconnect:SetText('Disconnect')
	self.disconnect:SetFont('nexus-frame-title')
	self.disconnect:SetPaintedManually(true)

	hook.Add('PostDrawOpaqueRenderables','login-screen',function() self:DrawScreen() end)
end

function pnl:Paint(w,h)

end

function pnl:DrawScreen()
	vgui.Start3D2D(self.model:GetPos()+Vector(0,15,75),Angle(0,65,90),.2)
		self.av:Paint3D2D()
		self.name:Paint3D2D()
		self.login:Paint3D2D()
		self.disconnect:Paint3D2D()
	vgui.End3D2D()
end

local TL = Angle(0,160,0)
local TR = Angle(0,128,0)
local BL = Angle(24,160,0)
local BR = Angle(-5,128,0)

function pnl:Think()
	local ang = LocalPlayer():EyeAngles()

	if ang.y > TL.y then LocalPlayer():SetEyeAngles(Angle(ang.p,TL.y,ang.r)) end
	if ang.y < TR.y then LocalPlayer():SetEyeAngles(Angle(ang.p,TR.y,ang.r)) end

	if ang.p > BL.p then LocalPlayer():SetEyeAngles(Angle(BL.p,ang.y,ang.r)) end
	if ang.p < BR.p then LocalPlayer():SetEyeAngles(Angle(BR.p,ang.y,ang.r)) end
end

pnl:registerPanel()