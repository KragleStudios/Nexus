local PANEL = {}
 
function PANEL:Init()
    self.cont = vgui.Create("NFrame")
    self.cont:SetTitle("")

    self.avatar = vgui.Create("AvatarImage", self.cont)
    self.avatar:SetPos(3, 3)
    self.avatar:SetSkin(derma.GetNamedSkin("Nexus"))
end
 
function PANEL:PerformLayout()
    self:OnSizeChanged(self:GetWide(), self:GetTall())
end

function PANEL:SetPos(x, y)
    self.cont:SetPos(x, y)
end
 
function PANEL:SetSteamID(...)
    self.avatar:SetSteamID(...)
end
 
function PANEL:SetPlayer(...)
    self.avatar:SetPlayer(...)
end
 
function PANEL:OnSizeChanged(w, h)
    self.cont:SetSize(w, h)
    self.avatar:SetSize(w-6, h-6)
end
  
vgui.Register("NAvatar", PANEL)