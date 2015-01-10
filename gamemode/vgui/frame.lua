local pnl = newPanel('NFrame','DFrame')

function pnl:Init()
	self.min = false
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
	self.cls:SetPos(self:GetWide()-15,3)
	self.cls.DoClick = function() self:Remove() end

	self.fcs = vgui.Create('DButton',self)
	self.fcs:SetFont('marlett')
	self.fcs:SetText('0')
	self.fcs:SetColor(color_white)
	self.fcs:SetDrawBackground(false)
	self.fcs:SetSize(15,15)
	self.fcs:SetPos(self:GetWide()-35,3)
	self.fcs.DoClick = function()
		self.min = !self.min
		self:MakePopup(!self.min)
		for _, x in pairs(self:GetChildren()) do
			if !IsValid(x) or x == self.cls or x == self.fcs or x == self.btnClose or x == self.btnMaxim or x == self.btnMinim then continue end
			x:SetVisible(!self.min)
		end
		if !LocalPlayer().minimizedBefore then
			LocalPlayer().minimizedBefore = true
			chat.AddText(Color(255,82,82),'[Nexus]',color_white,'You can press Z to enable the cursor!')
		end

	end

end

function pnl:Paint(w,h)
	surface.SetDrawColor(0,0,0,200)
	surface.DrawRect(0,0,w,20)
	surface.SetDrawColor(self:HasFocus() and self.oCol or Color(211,211,211,255))
	surface.DrawRect(0,0,8,20)
	surface.DrawOutlinedRect(0,0,w,20)
	if self.title then
		draw.SimpleText(self.title,'nexus-frame-title',15,10,color_white,nil,1)
	end

	if self.min then return end
	surface.SetDrawColor(0,0,0,200)
	surface.DrawRect(0,30,w,h-30)
	surface.SetDrawColor(self:HasFocus() and self.oCol or Color(211,211,211,255))
	surface.DrawOutlinedRect(0,30,w,h-30)

end

function pnl:SetTagColor(col)
	self.oCol = col
end

function pnl:SetTitle(str)
	self.title = str
end

pnl:registerPanel()