local pnl = newPanel('NAvatar','DPanel')

function pnl:Init()
	self:SetSize(80,80)
	self.avatar = vgui.Create('AvatarImage',self)
	self.avatar:SetPos(2,2)
	self.avatar:SetPlayer(LocalPlayer(),64)
	self.avatar:SetSize(76,76)
	self.skin = derma.GetNamedSkin('Nexus')
end

function pnl:Paint(w,h)
	draw.RoundedBox(4,0,0,w,h,self.skin.FrameBGColor)
	draw.RoundedBox(4,1,1,w-2,h-2,self.skin.FrameBorderColor)
end

pnl:registerPanel()