concommand.Add('gen_ui',function(ply,cmd,args)
	gui.EnableScreenClicker(true)

	local f = vgui.Create('NFrame')
	f:SetTitle(" ")
	f.title = "Welcome!"
	f:SetSize(ScrW() - 200, ScrH() - 100)
	f:Center()

	surface.SetFont( "DermaLarge" )
	local tw, th = surface.GetTextSize( f.title )

	local p = vgui.Create("NPanel", f)
	p:SetPos(5, th + 25)
	p:SetSize(f:GetWide() - 10, f:GetTall() - (th + 80))

	http.Fetch( "https://raw.githubusercontent.com/GMod-Nexus/Nexus/master/README.md", 
		function( body, len, headers, code )
			local scroll = vgui.Create("DScrollPanel", p)
			scroll:SetSize(p:GetWide() - 30, p:GetTall() - 30)
			scroll:SetPos(15, 15)

			local lbl = vgui.Create("DLabel", scroll)
			lbl:SetText(body)
			//lbl:SetText(shit)
			lbl:SetFont("nexus-button")
			lbl:SizeToContents()
			lbl:SetWide(scroll:GetWide())

			lbl:SetWrap(true)


			local b = vgui.Create('NButton',f)
			b:SetSkin("Nexus")
			b:SetText("Close")
			b:SetSize(200, 50)
			b:SetPos(0, f:GetTall() - 55)
			b:CenterHorizontal()
			function b:DoClick()
				f:Close()
				gui.EnableScreenClicker(false)
			end
		end, 
		function( error )
		end)

	
end)