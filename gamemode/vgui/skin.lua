local surface = surface
local draw = draw
local Color = Color

local SKIN = {}

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

--[[---------------------------------------------------------
	Frame
-----------------------------------------------------------]]
local PANEL = {}

AccessorFunc( PANEL, "m_bIsMenuComponent", 		"IsMenu", 			FORCE_BOOL )
AccessorFunc( PANEL, "m_bDraggable", 			"Draggable", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bSizable", 				"Sizable", 			FORCE_BOOL )
AccessorFunc( PANEL, "m_bScreenLock", 			"ScreenLock", 		FORCE_BOOL )
AccessorFunc( PANEL, "m_bDeleteOnClose", 		"DeleteOnClose", 	FORCE_BOOL )
AccessorFunc( PANEL, "m_bPaintShadow", 			"PaintShadow", 		FORCE_BOOL )

AccessorFunc( PANEL, "m_iMinWidth", 			"MinWidth" )
AccessorFunc( PANEL, "m_iMinHeight", 			"MinHeight" )

AccessorFunc( PANEL, "m_bBackgroundBlur", 		"BackgroundBlur", 	FORCE_BOOL )

function PANEL:Init()

	self:SetTitle( "" )

	PANEL.Title = ""
	self.Title = ""
	function PANEL:SetTitle(str)
		self.Title = str
	end
	
	self:SetFocusTopLevel( true )

	self:SetPaintShadow( true )

	self:ShowCloseButton(false)
	self:SetDraggable( true )
	self:SetSizable( false )
	self:SetScreenLock( false )
	self:SetDeleteOnClose( true )

	self:SetMinWidth( 50 )
	self:SetMinHeight( 50 )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

	self.m_fCreateTime = SysTime()

	self:DockPadding( 5, 24 + 5, 5, 5 )

end

function PANEL:Paint( w, h )

	if ( self.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end

	draw.RoundedBox( 4, 0, 0, w, h, SKIN.FrameOutlineColor )
	draw.RoundedBox( 4, 1, 1, w - 2, h - 2, SKIN.FrameBorderColor )
	draw.RoundedBox( 4, 2, 2, w - 4, h - 4, SKIN.FrameBGColor )
	surface.SetFont( "DermaLarge" )
	self.TitleW, self.TitleH = surface.GetTextSize( self.Title )
	draw.RoundedBoxEx( 4, 2, 2, w - 4, self.TitleH + 20, SKIN.FrameTitleBGColor, true, true )
	surface.SetTextPos( w / 2 - self.TitleW / 2, 10 )
	surface.SetTextColor( 221, 221, 221 )
	surface.DrawText( self.Title )

end

function PANEL:OnMousePressed()

	if ( self.m_bSizable ) then

		if ( gui.MouseX() > ( self.x + self:GetWide() - 20 ) &&
			gui.MouseY() > ( self.y + self:GetTall() - 20 ) ) then

			self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
			self:MouseCapture( true )
			return
		end

	end

	if ( self:GetDraggable() && gui.MouseY() < (self.y + self.TitleH + 20) ) then
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
		return
	end

end

function PANEL:Think()

	local mousex = math.Clamp( gui.MouseX(), 1, ScrW()-1 )
	local mousey = math.Clamp( gui.MouseY(), 1, ScrH()-1 )

	if ( self.Dragging ) then

		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if ( self:GetScreenLock() ) then

			x = math.Clamp( x, 0, ScrW() - self:GetWide() )
			y = math.Clamp( y, 0, ScrH() - self:GetTall() )

		end

		self:SetPos( x, y )

	end

	if ( self.Sizing ) then

		local x = mousex - self.Sizing[1]
		local y = mousey - self.Sizing[2]
		local px, py = self:GetPos()

		if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW() - px and self:GetScreenLock() ) then x = ScrW() - px end
		if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH() - py and self:GetScreenLock() ) then y = ScrH() - py end

		self:SetSize( x, y )
		self:SetCursor( "sizenwse" )
		return

	end

	if ( self.Hovered && self.m_bSizable &&
		 mousex > ( self.x + self:GetWide() - 20 ) &&
		 mousey > ( self.y + self:GetTall() - 20 ) ) then

		self:SetCursor( "sizenwse" )
		return

	end

	if ( self.Hovered && self:GetDraggable() && mousey < ( self.y + self.TitleH + 20 ) ) then
		self:SetCursor( "sizeall" )
		return
	end

	self:SetCursor( "arrow" )

	-- Don't allow the frame to go higher than 0
	if ( self.y < 0 ) then
		self:SetPos( self.x, 0 )
	end

end

derma.DefineControl("NFrame", "Nexus frame with big title", PANEL, "DFrame")

--[[---------------------------------------------------------
	HUD Frame
-----------------------------------------------------------]]
local HUDPANEL = {}

function HUDPANEL:Init()

	self:SetTitle( "" )
	self:ShowCloseButton( false )

	function self:SetTitle() return end
	function self:ShowCloseButton() return end

end

function HUDPANEL:Paint( w, h )

	draw.RoundedBox( 4, 0, 0, w, h, SKIN.FrameOutlineColor )
	draw.RoundedBox( 4, 1, 1, w - 2, h - 2, SKIN.FrameBorderColor )
	draw.RoundedBox( 4, 2, 2, w - 4, h - 4, SKIN.FrameBGColor )

end

derma.DefineControl("NHUDFrame", "Nexus HUD Frame", HUDPANEL, "DFrame")
