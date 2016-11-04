local PANEL = {}

AccessorFunc( PANEL, "m_bBorder", "DrawBorder", FORCE_BOOL )

function PANEL:Init()

	self:SetContentAlignment( 5 )

	--
	-- These are Lua side commands
	-- Defined above using AccessorFunc
	--
	self:SetDrawBorder( true )
	self:SetPaintBackground( true )

	self:SetTall( 22 )
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

	self:SetCursor( "hand" )
	self:SetFont( "DermaDefault" )

	self.outline = SKIN.FrameOutlineColor

	self:SetText("")
	self:SetSkin("Nexus")
end

function PANEL:IsDown()

	return self.Depressed

end

function PANEL:SetImage( img )

	if ( !img ) then

		if ( IsValid( self.m_Image ) ) then
			self.m_Image:Remove()
		end

		return
	end

	if ( !IsValid( self.m_Image ) ) then
		self.m_Image = vgui.Create( "DImage", self )
	end

	self.m_Image:SetImage( img )
	self.m_Image:SizeToContents()
	self:InvalidateLayout()

end
PANEL.SetIcon = PANEL.SetImage

function PANEL:SetTitle(text)
	self.Title = text
end

function PANEL:GetTitle(text)
	return self.Title
end

function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "Button", self, w, h )

	local borderColor = SKIN.ButtonBorderColor
	local backgroundColor = SKIN.ButtonBGColor

	if self.Hovered then
		borderColor = SKIN.ButtonHoverColor
	end

	if self.Depressed or self:IsSelected() or self:GetToggle() then
		borderColor = SKIN.ButtonClickColor
	end
	
	if self:GetDisabled() then
		borderColor = SKIN.ButtonBorderColor
	end	

	draw.RoundedBox( 8, 0, 0, w, h, SKIN.ButtonOutlineColor )
	draw.RoundedBox( 8, 1, 1, w - 2, h - 2, borderColor )
	draw.RoundedBox( 8, 2, 2, w - 4, h - 4, backgroundColor )
	self:SetColor( borderColor )

	local text = self.Title

	surface.SetFont( nx.fonts.default:fitToView(w - 10, h, text) )
	
	width, height = surface.GetTextSize( text )

	surface.SetTextPos( w / 2 - width / 2, h / 2 - height / 2 )
	surface.SetTextColor(borderColor)
	surface.DrawText( text )

	if (self:GetDisabled()) then
		SKIN:DoDisabled(self, w, h)
	end


	return false
end

function PANEL:UpdateColours( skin )

	if ( !self:IsEnabled() )					then return self:SetTextStyleColor( skin.Colours.Button.Disabled ) end
	if ( self:IsDown() || self.m_bSelected )	then return self:SetTextStyleColor( skin.Colours.Button.Down ) end
	if ( self.Hovered )							then return self:SetTextStyleColor( skin.Colours.Button.Hover ) end

	return self:SetTextStyleColor( skin.Colours.Button.Normal )

end

function PANEL:PerformLayout()

	--
	-- If we have an image we have to place the image on the left
	-- and make the text align to the left, then set the inset
	-- so the text will be to the right of the icon.
	--
	if ( IsValid( self.m_Image ) ) then

		self.m_Image:SetPos( 4, ( self:GetTall() - self.m_Image:GetTall() ) * 0.5 )

		self:SetTextInset( self.m_Image:GetWide() + 16, 0 )

	end

	DLabel.PerformLayout( self )

end

function PANEL:SetConsoleCommand( strName, strArgs )

	self.DoClick = function( self, val )
		RunConsoleCommand( strName, strArgs )
	end

end

function PANEL:SizeToContents()
	local w, h = self:GetContentSize()
	self:SetSize( w + 8, h + 4 )
end


derma.DefineControl( "NButton", "A standard Button", PANEL, "DLabel" )