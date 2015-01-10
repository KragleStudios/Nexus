local pnl = newPanel('NButton','DButton')

function pnl:Init()
	self:SetOutlineColor(Color(211,211,211,255))
	self:SetHoverColor(Color(255,102,102,255))
	self:SetSize(100,40)
	self:SetColor(self.oCol)
	self:SetFont('nexus-button')
	self:SetText('Button')
end

function pnl:Paint(w,h)
	draw.RoundedBox(8,0,0,w,h,Color(32,32,32,255))
	draw.RoundedBox(8,4,4,w-8,h-8,self.hover and self.hCol or self.oCol)
	draw.RoundedBox(8,6,6,w-12,h-12,Color(32,32,32,255))
end

function pnl:OnCursorEntered()
	self.hover = true
end

function pnl:OnCursorExited()
	self.hover = false
end

function pnl:SetOutlineColor(col)
	self.oCol = col
end

function pnl:SetHoverColor(col)
	self.hCol = col
end

pnl.UpdateColours = function() end

pnl:registerPanel()