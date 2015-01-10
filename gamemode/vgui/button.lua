local pnl = newPanel('NButton','DButton')

function pnl:Init()
	self:SetTagColor(Color(211,211,211,255))
	self:SetHoverColor(Color(255,82,82,255))
	self:SetSize(100,40)
	self:SetColor(color_white)
	self:SetFont('nexus-button')
	self:SetText('Button')
end

function pnl:Paint(w,h)
	surface.SetDrawColor(0,0,0,150)
	surface.DrawRect(0,0,w,h)
	surface.SetDrawColor(self.hover and self.hCol or self.oCol)
	surface.DrawRect(0,0,8,h)
end

function pnl:OnCursorEntered()
	self.hover = true
end

function pnl:OnCursorExited()
	self.hover = false
end

function pnl:SetTagColor(col)
	self.oCol = col
end

function pnl:SetHoverColor(col)
	self.hCol = col
end

pnl.UpdateColours = function() end

pnl:registerPanel()