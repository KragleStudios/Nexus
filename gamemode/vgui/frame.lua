local pnl = newPanel('NFrame','DFrame')

function pnl:Init()
	self:MakePopup()
	self:Center()
	self.lblTitle:SetText('')
	self:SetSize(400,400)
	self:ShowCloseButton(false)
	self:SetTitle('Frame')
	self:SetOutlineColor(Color(211,211,211,255))
end

function pnl:Paint(w,h)
	draw.RoundedBox(8,0,0,w,h,Color(32,32,32,255))
	draw.RoundedBox(8,4,4,w-8,h-8,self.oCol)
	draw.RoundedBox(8,6,6,w-12,h-12,Color(32,32,32,255))
	if !self.title then return end
	surface.SetDrawColor(Color(0,0,0,100))
	surface.DrawRect(0,20,w,90)
	draw.SimpleText(self.title,'nexus-frame-title',w/2,60,Color(211,211,211,255),1,1)
end

function pnl:SetOutlineColor(col)
	self.oCol = col
end

function pnl:SetTitle(str)
	self.title = str
end

pnl:registerPanel()