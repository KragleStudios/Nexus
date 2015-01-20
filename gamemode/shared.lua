GM.Name 	= "Nexus"
GM.Author 	= "GModCoders"
GM.Email 	= "N/A"
GM.Website 	= "glua.me"
GM.Path 	= "gamemodes/nexus/gamemode"

DeriveGamemode("sandbox")

NX = NX or {}

function GM:Initialize()
	self.BaseClass.Initialize( self )
end
