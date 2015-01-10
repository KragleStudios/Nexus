local pnl = newPanel('NPanel','DPanel')

function pnl:Init()
	self:SetSize(400,400)
	self:SetOutlineColor(Color(211,211,211,255))
end

function pnl:Paint(w,h)
	self:DrawBackground(w,h)
end

function pnl:DrawBackground(w,h)
	draw.RoundedBox(8,0,0,w,h,Color(32,32,32,255))
	draw.RoundedBox(8,4,4,w-8,h-8,self.oCol)
	draw.RoundedBox(8,6,6,w-12,h-12,Color(32,32,32,255))
end

function pnl:SetOutlineColor(col)
	self.oCol = col
end

pnl:registerPanel()