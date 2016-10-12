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

--[[---------------------------------------------------------
	Frame
-----------------------------------------------------------]]
function SKIN:PaintFrame( panel, w, h )

	draw.RoundedBox( 8, 0, 0, w, h, SKIN.FrameOutlineColor )
	draw.RoundedBox( 8, 1, 1, w - 2, h - 2, SKIN.FrameBorderColor )
	draw.RoundedBox( 8, 2, 2, w - 4, h - 4, SKIN.FrameBGColor )

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

	draw.RoundedBox( 8, 0, 0, w, h, self.FrameOutlineColor )
	draw.RoundedBox( 8, 1, 1, w - 2, h - 2, borderColor )
	draw.RoundedBox( 8, 2, 2, w - 4, h - 4, backgroundColor )

	panel:SetColor( borderColor )

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