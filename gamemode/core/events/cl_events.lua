concommand.Add("loadmenu", function()
	local bg = vgui.Create("NFrame")
	bg:SetHeader("Create New Event")
	bg:SetWide(ScrW() / 3)
	bg:SetTall(ScrH() / 1.5)
	bg:Center()
	bg:MakePopup()

	local width = bg:GetWide() / 2
	local w, h = bg:GetWide(), bg:GetTall()

	local font = nx.fonts.default:fitToView(width - 5, 35, "Which event do you want to start?")


	local event_name, event_type, private, loc = nil, nil, false, nil

	local name_lbl = vgui.Create("DLabel", bg)
	name_lbl:SetSize(width, 35)
	name_lbl:SetText("What is the name for your event?")
	name_lbl:SetFont(font)
	name_lbl:SetPos(5, 55)

	local name = vgui.Create("DTextEntry", bg)
	name:SetSkin("Nexus")
	name:SetValue("")
	name:SetPos(w / 2, 60)
	name:SetSize(width - 5, 25)
	name:SetNumeric(false)
	function name:OnTextChanged()
		event_name = self:GetValue()
	end


	local event_lbl = vgui.Create("DLabel", bg)
	event_lbl:SetSize(width, 35)
	event_lbl:SetText("Which event do you want to start?")
	event_lbl:SetFont(font)
	event_lbl:SetPos(5, 85)

	local event = vgui.Create("DComboBox", bg)
	event:SetSize(width - 5, 25)
	event:SetSkin("Nexus")
	event:SetPos(w / 2, 90)
	event:SetValue("Event...")
	function event:OnSelect(ind, val, dat)
		event_type = val
	end


	local private_lbl = vgui.Create("DLabel", bg)
	private_lbl:SetSize(width, 35)
	private_lbl:SetText("Is this event private?")
	private_lbl:SetFont(font)
	private_lbl:SetPos(5, 115)

	local private = vgui.Create("DCheckBox", bg)
	private:SetSize(25, 25)
	private:SetSkin("Nexus")
	private:SetPos(w / 2, 120)
	function private:OnChange(val)
		private = val
	end


	local loc_lbl = vgui.Create("DLabel", bg)
	loc_lbl:SetSize(width, 35)
	loc_lbl:SetText("Where is this going to be?")
	loc_lbl:SetFont(font)
	loc_lbl:SetPos(5, 145)

	local locations = vgui.Create("DComboBox", bg)
	locations:SetSize(width - 5, 25)
	locations:SetSkin("Nexus")
	locations:SetPos(w / 2, 150)
	locations:SetValue("Location...")
	function locations:OnSelect(ind, val, dat)
		loc = val
	end

	for ev_name,v in ndoc.pairs(ndoc.table.nxEvents) do
		event:AddChoice(ev_name)

		for e,i in ndoc.pairs(v.locations) do
			locations:AddChoice(i)
		end
	end

	local invites = {}
	local plist = vgui.Create("DListView", bg)
	--plist:SetMultiSelect(true)
	plist:AddColumn("Players")
	plist:AddColumn("SteamID")
	plist:SetSkin("Nexus")
	plist:SetSize(w - 10, h - 180 - 40)
	plist:SetPos(5, 180)
	for k,v in pairs(player.GetAll()) do
		plist:AddLine(v:Nick(), v:SteamID())
	end
	function plist:OnClickLine(line, isselected)
		invites[ line:GetValue(2) ] = isselected or nil
	end

	local create = vgui.Create("NButton", bg)
	create:SetSize(width - 7, 30)
	create:SetPos(5, h - 35)
	create:SetTitle("Create Event")
	create:SetDisabled(true)
	function create:Think()
		if (event_name && string.len(event_name) > 1 && event_type && loc) then
			self:SetDisabled(false)
		else
			self:SetDisabled(true)
		end
	end
	function create:DoClick()
		net.Start("nx.create_event")
			net.WriteString(event_name)
			net.WriteString(event_type)
			net.WriteBool(private)
			net.WriteString(loc)
			net.WriteTable(invites)
		net.SendToServer()

		bg:Close()
	end	

	local cancel = vgui.Create("NButton", bg)
	cancel:SetSize(width - 5, 30)
	cancel:SetPos(w / 2, h - 35)
	cancel:SetTitle('Cancel')
	function cancel:DoClick()
		bg:Close()
	end
end)