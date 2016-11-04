local surface = surface
local draw = draw
local Color = Color

SKIN = {}

SKIN.PrintName 		= "Nexus Derma Skin"
SKIN.Author 		= "Alexander Sagen (TrinityX)"
SKIN.DermaVersion	= 1


SKIN.FrameBGColor		= Color( 32, 32, 32 )
SKIN.FrameBorderColor	= Color( 221, 221, 221 )
SKIN.FrameOutlineColor	= Color( 0, 0, 0 )
SKIN.FrameTitleBGColor	= Color( 0, 0, 0 )

SKIN.ButtonBGColor = SKIN.FrameBGColor
SKIN.ButtonOutlineColor = SKIN.FrameOutlineColor
SKIN.ButtonBorderColor = SKIN.FrameBorderColor
SKIN.ButtonHoverColor = Color(41, 171, 226)
SKIN.ButtonClickColor = Color(0, 113, 188)

SKIN.TextBoxBorderColor = Color(0, 0, 0)
SKIN.TextBoxBGColor = Color(255, 255, 255)
SKIN.TextBoxHoverColor = Color(245, 245, 245)
SKIN.TextBoxActiveColor = Color(255, 255, 255)
SKIN.TextBoxOutlineColor = Color(255, 255, 255)

SKIN.ScrollBarHovered = Color(41, 171, 226)
SKIN.ScrollBarDepressed = Color(0, 113, 188)
SKIN.ScrollBar = Color(221, 221, 221)

SKIN.ListViewLineColor = {
	[1] = Color(255, 255, 255),
	[2] = Color(240, 240, 240)
}

local distance_between = 20
local rect_width = 12
local DisabledColor = Color(100, 100, 100)

--TODO: Improve this
function SKIN:DoDisabled(panel, w, h)
	local rect_height = h * 3
	local num_rects = math.ceil(w / (rect_width + distance_between))

	draw.NoTexture()
	surface.SetDrawColor(DisabledColor)

	for i = 0, num_rects do
		surface.DrawTexturedRectRotated(i * (rect_width + distance_between), h / 2, rect_width, rect_height, 45)
	end

end

--[[---------------------------------------------------------
	Button
-----------------------------------------------------------]]
function SKIN:PaintButton( panel, w, h )

	local borderColor = self.FrameBorderColor
	local backgroundColor = self.FrameBGColor

	if panel.Hovered then
		borderColor = Color( 41, 171, 226 )
	end

	if panel.Depressed or panel:IsSelected() or panel:GetToggle() then
		borderColor = Color( 0, 113, 188 )
	end
	
	if panel:GetDisabled() then
		borderColor = self.FrameBorderColor
		backgroundColor = Color(80, 80, 80)
	end	

	draw.RoundedBox( 6, 0, 0, w, h, self.FrameOutlineColor )
	draw.RoundedBox( 6, 1, 1, w - 2, h - 2, borderColor )
	draw.RoundedBox( 6, 2, 2, w - 4, h - 4, backgroundColor )

	panel:SetColor( borderColor )

end

function SKIN:PaintTextEntry(pnl, w, h)
	local borderColor = SKIN.TextBoxBorderColor
	local backgroundColor = SKIN.TextBoxBGColor

	if pnl.Hovered then
		backgroundColor = SKIN.TextBoxHoverColor
	end

	if pnl.Depressed or pnl:IsSelected() then
		backgroundColor = SKIN.TextBoxActiveColor
	end
	
	if pnl:GetDisabled() then
		borderColor = SKIN.TextBoxBorderColor
		backgroundColor = Color(80, 80, 80)
	end	

	draw.RoundedBox( 6, 0, 0, w, h, SKIN.TextBoxOutlineColor )
	draw.RoundedBox( 6, 1, 1, w - 2, h - 2, borderColor )
	draw.RoundedBox( 6, 2, 2, w - 4, h - 4, backgroundColor )

	if (pnl:GetDisabled()) then
		SKIN:DoDisabled(pnl, w, h)
	end

	pnl:DrawTextEntryText(Color(0, 0, 0), Color(0, 0, 0), Color(0, 0, 0))
end

function SKIN:PaintListViewLine(panel, w, h)
	local id = panel:GetID()
	local col = SKIN.ListViewLineColor[ 1 ]
	if (id % 2 ~= 0) then
   		col = SKIN.ListViewLineColor[ 2 ]
	end

	selected = Color(0, 0, 0, 0)
	if (panel:IsSelected()) then
		selected = Color(0, 0, 0, 255)
	end

	local height = (h - 2)
	
   	draw.RoundedBox(0, 0, 0, w, h, col) 
   	draw.RoundedBox(6, w - height - 1, 1, height, height, selected)
end

function SKIN:PaintListView(panel, w, h)
	draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 0))
end

function SKIN:PaintVScrollBar(panel, w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
end

function SKIN:PaintScrollBarGrip(panel, w, h)
	col = SKIN.ScrollBar

	if (panel.Depressed || panel:IsSelected()) then
		col = SKIN.ScrollBarDepressed
	end

	if (panel.Hovered) then
		col = SKIN.ScrollBarHovered
	end

	draw.RoundedBox(0, 0, 0, w, h, col)
end

function SKIN:PaintButtonDown(panel, w, h)
	col = SKIN.ScrollBar

	if (panel.Depressed || panel:IsSelected()) then
		col = SKIN.ScrollBarDepressed
	end

	if (panel.Hovered) then
		col = SKIN.ScrollBarHovered
	end

	draw.RoundedBox(0, 0, 0, w, h, col)
end

function SKIN:PaintButtonUp(panel, w, h)
	col = SKIN.ScrollBar

	if (panel.Depressed || panel:IsSelected()) then
		col = SKIN.ScrollBarDepressed
	end

	if (panel.Hovered) then
		col = SKIN.ScrollBarHovered
	end

	draw.RoundedBox(0, 0, 0, w, h, col)
end

--[[---------------------------------------------------------
	Checkbox
-----------------------------------------------------------]]
function SKIN:PaintCheckBox( panel, w, h )

	local borderColor = self.FrameBorderColor

	if panel.Hovered then
		borderColor = Color( 41, 171, 226 )
	end

	if panel.Depressed then
		borderColor = Color( 0, 113, 188 )
	end

	draw.RoundedBox( 4, 0, 0, w, h, self.FrameOutlineColor )
	draw.RoundedBox( 4, 1, 1, w - 2, h - 2, borderColor )
	draw.RoundedBox( 4, 2, 2, w - 4, h - 4, self.FrameBGColor )

	if panel:GetChecked() then
	
		if panel:GetDisabled() then
			draw.RoundedBox( 4, 4, 4, w - 8, h - 8, Color( 80, 80, 80 ) )
		else
			draw.RoundedBox( 4, 4, 4, w - 8, h - 8, self.FrameBorderColor )
		end

	end

end

--[[---------------------------------------------------------
	Button
-----------------------------------------------------------]]
function SKIN:PaintWindowCloseButton( panel, w, h )

	if not panel.m_bBackground then return end

	panel:SetText( "x" )
	panel:SetColor( Color( 255, 255, 255 ) )
	
	if panel.Hovered then
		panel:SetColor( Color( 41, 171, 226 ) )
	end

	if panel.Depressed or panel:IsSelected() then
		panel:SetColor( Color( 0, 113, 188 ) )
	end
	
	if panel:GetDisabled() then
		panel:SetColor( Color( 255, 255, 255, 50 ) )
	end

end

derma.DefineSkin( "Nexus", "The Nexus gamemode's derma skin.", SKIN )