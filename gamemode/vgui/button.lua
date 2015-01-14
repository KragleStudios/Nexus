local pnl = newPanel('NButton','DButton')

function pnl:Init()
	self.UpdateColours = function() return end
	self:SetText('Button')
	self.skin = derma.GetNamedSkin('Nexus')
	self:SetColor(Color(211,211,211))
	self:SetFont('nexus-button')
end

function pnl:Paint(w,h)
	draw.RoundedBox( 4, 0, 0, w, h, self.skin.FrameOutlineColor )
	draw.RoundedBox( 4, 1, 1, w - 2, h - 2, self.Hovered and Color( 41, 171, 226 ) or self.skin.FrameBorderColor )
	draw.RoundedBox( 4, 2, 2, w - 4, h - 4, self.skin.FrameBGColor )
end

pnl:registerPanel()