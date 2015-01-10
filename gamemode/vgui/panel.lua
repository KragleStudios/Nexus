local pnl = newPanel('NPanel','DPanel')

function pnl:Init()
	self:SetSize(400,400)
end

function pnl:Paint(w,h)
	surface.SetDrawColor(0,0,0,150)
	surface.DrawRect(0,30,w,h-30)
end

pnl:registerPanel()