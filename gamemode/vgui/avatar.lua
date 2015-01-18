local pnl = newPanel('NAvatar','DPanel')

function pnl:Init()
	self:SetSize(80,80)
	self.avatar = vgui.Create('AvatarImage',self)
	self.avatar:SetPos(4,4)
	self.avatar:SetPlayer(LocalPlayer(),64)
	self.avatar:SetSize(72,72)
	self.skin = derma.GetNamedSkin('Nexus')
end

function pnl:Paint(w,h)
	draw.RoundedBox(8,0,0,w,h,self.skin.FrameBorderColor)
end

pnl:registerPanel()