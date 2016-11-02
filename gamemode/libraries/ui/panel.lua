
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
	self:ShowCloseButton(false)
	
	self:SetFocusTopLevel( true )

	self:SetPaintShadow( true )

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

	self:SetTitle("")
end

function PANEL:SetHeader(...)
	self.title = ...

	self:SetTitle("")
	self.TitleH, self.TitleW = 0, 0
end

function PANEL:GetTitle()
	return self.title or ""
end

 
function PANEL:GetContentArea()
	local titleHeight = self.TitleH or 0
	local panelHeight = self:GetTall()

	local panelWidth = self:GetWide()

	return 3, titleHeight + 4, panelHeight - titleHeight, panelWidth
end

function PANEL:Paint( w, h )

	if ( self.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end

	draw.RoundedBox( 6, 0, 0, w, h, SKIN.FrameOutlineColor )
	draw.RoundedBox( 6, 1, 1, w - 2, h - 2, SKIN.FrameBorderColor )
	draw.RoundedBox( 6, 2, 2, w - 4, h - 4, SKIN.FrameBGColor )
	
	surface.SetFont( nx.fonts.default:fitToView(w - 10, (h < 30 and h) or 30, self:GetTitle()) )
	if (self:GetTitle() and string.len(self:GetTitle()) >= 1) then
		self.TitleW, self.TitleH = surface.GetTextSize( self:GetTitle() )

		draw.RoundedBoxEx( 4, 2, 2, w - 4, self.TitleH + 5, SKIN.FrameTitleBGColor, true, true )
		surface.SetTextPos( w / 2 - self.TitleW / 2, 3 )
		surface.SetTextColor( 221, 221, 221 )
		surface.DrawText( self:GetTitle() )
	end

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