local pnl = newPanel('NFrame','DFrame')

function pnl:Init()
	self:MakePopup()
	self.lblTitle:SetText('')
	self:SetSize(400,400)
	self:Center()
	self:ShowCloseButton(false)
	self:SetTitle('Frame')
	self:SetTagColor(Color(255,82,82,255))

	self.cls = vgui.Create('DButton',self)
	self.cls:SetFont('marlett')
	self.cls:SetText('r')
	self.cls:SetColor(color_white)
	self.cls:SetDrawBackground(false)
	self.cls:SetSize(15,15)
	self.cls:SetPos(self:GetWide()-self.cls:GetWide(),3)
	self.cls.DoClick = function() self:Remove() end
end

function pnl:Paint(w,h)
	surface.SetDrawColor(0,0,0,150)
	surface.DrawRect(0,30,w,h-30)
	surface.DrawRect(0,0,w,20)
	surface.SetDrawColor(self:HasFocus() and self.oCol or Color(211,211,211,255))
	surface.DrawRect(0,0,8,20)
	if not self.title then return end
	draw.SimpleText(self.title,'nexus-frame-title',15,10,color_white,nil,1)
end

function pnl:SetTagColor(col)
	self.oCol = col
end

function pnl:SetTitle(str)
	self.title = str
end

pnl:registerPanel()