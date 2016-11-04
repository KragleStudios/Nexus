local daddy

local function createHUD()
	local x_offset_right = 10
	local y_offset_top   = 10
	daddy = true

	local avatar = vgui.Create("NAvatar")
	avatar:SetSize(96, 96)
	avatar:SetPlayer(LocalPlayer(), 64)

	x_offset_right = x_offset_right + avatar:GetWide()

	avatar:SetPos(ScrW() - x_offset_right, y_offset_top)

	y_offset_top = y_offset_top + avatar:GetTall() + 5

	local name = vgui.Create("NFrame")
	name:SetPos(ScrW() - x_offset_right, y_offset_top)
	name:SetSize(96, 50)
	name:SetHeader(LocalPlayer():Nick())

	local titlex, titley, spacey, spacex = name:GetContentArea()

	local nexi = vgui.Create("DLabel", name)
	nexi:SetPos(0, spacey / 2)
	
	local function updateNexi()
		local money = LocalPlayer():getNexi() .. " Nexi"
		local moneyFont = nx.fonts.default:fitToView(spacex, spacey / 3, money)
		nexi:CenterHorizontal(.5)
		nexi:SetContentAlignment(5)
		nexi:SetFont(moneyFont)
		nexi:SetText(money)
	end
	updateNexi()

	ndoc.observe(LocalPlayer():GetData(), 'nc.onnexichanged', function(val)
		updateNexi()
	end)

	local infoDaddy
	local function createInfoBars()
	/*	if (not LocalPlayer():inEvent()) then 
			if (infoDaddy) then 
				infoDaddy():Remove()
			end
			return 
		end*/
	
		infoDaddy = vgui.Create("NFrame")
		infoDaddy:SetSize(210, 47)
		infoDaddy:SetPos(10, 10)

		--Images
		local healthImg = vgui.Create("DImage", infoDaddy)
		healthImg:SetPos(5, 5)
		healthImg:SetSize(16, 16)
		healthImg:SetImageColor(Color(255, 255, 255))
		healthImg:SetImage("nexus/heart.png")

		local armorImg = vgui.Create("DImage", infoDaddy)
		armorImg:SetPos(5, 26)
		armorImg:SetSize(16, 16)
		armorImg:SetImageColor(Color(255, 255, 255))
		armorImg:SetImage("nexus/shield.png")

		local ammoImg = vgui.Create("DImage", infoDaddy)
		ammoImg:SetPos(5, 47)
		ammoImg:SetSize(16, 16)
		ammoImg:SetImageColor(Color(255, 255, 255))
		ammoImg:SetImage("nexus/bullets.png")

		hook.Add("PlayerSwitchWeapon", "PlayerWeaponThing", function(ply, _, wep)
			if (ply == LocalPlayer()) then				
				local ammo = wep:Clip1()
				local maxAmmo = wep:GetMaxClip1()

				if (ammo and maxAmmo and ammo >= 0) then
					infoDaddy:SetTall(68)
				else
					infoDaddy:SetTall(47)
				end
			end
		end)

		--Bars
		local healthBar = vgui.Create("DPanel", infoDaddy)
		healthBar:SetSize(infoDaddy:GetWide() - 30, 16)
		healthBar:SetPos(25, 5)

		local col = Color(255, 25, 25, 255)
		local maxHealth = LocalPlayer():GetMaxHealth()
		function healthBar:Paint(w, h)
			local health = LocalPlayer():Health()
			local barLength = (health / maxHealth) * w

			draw.RoundedBox(4, 0, 0, barLength, h, col)
		end

		local armorBar = vgui.Create("DPanel", infoDaddy)
		armorBar:SetSize(infoDaddy:GetWide() - 30, 16)
		armorBar:SetPos(25, 10 + healthBar:GetTall())

		local col = Color(25, 25, 255, 255)
		function armorBar:Paint(w, h)
			local armor = LocalPlayer():Armor()

			if (armor == 0) then return end

			local barLength = (armor / 100) * w

			draw.RoundedBox(4, 0, 0, barLength, h, col)
		end

		local ammoBar = vgui.Create("DPanel", infoDaddy)
		ammoBar:SetSize(infoDaddy:GetWide() - 30, 16)
		ammoBar:SetPos(25, 15 + healthBar:GetTall() + armorBar:GetTall())

		local col = Color(255, 215, 25, 255)
		function ammoBar:Paint(w, h)
			local wep = LocalPlayer():GetActiveWeapon()
			if (not IsValid(wep)) then return end
			
			local ammo = wep:Clip1()
			local maxAmmo = wep:GetMaxClip1()

			if (ammo <= 0) then return end

			local barLength = (ammo / maxAmmo) * w

			draw.RoundedBox(4, 0, 0, barLength, h, col)
		end

	end
	createInfoBars()


end

hook.Add("HUDPaint", "ShowCustomHUD", function()
	if (not daddy) then createHUD() end
end)

local toHide = {
	CHudHealth = true,
	CHudBattery = true,
}

hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name)
	return not toHide[ name ]
end)

concommand.Add("reload_hud", function()
	daddy:Remove()

	createHUD()
end)