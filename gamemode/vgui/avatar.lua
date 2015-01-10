local pnl = newPanel('NAvatar','NPanel')

function pnl:Init()
	self:SetSize(80,70)
	self:SetTagColor(Color(255,82,82,255))
	self.avatar = vgui.Create('AvatarImage',self)
	self.avatar:SetPos(10,0)
	self.avatar:SetPlayer(LocalPlayer(),64)
	self.avatar:SetSize(70,70)
end

function pnl:Paint(w,h)
	surface.SetDrawColor(self.oCol)
	surface.DrawRect(0,0,10,h)
end

function pnl:SetTagColor(col)
	self.oCol = col
end

pnl:registerPanel()