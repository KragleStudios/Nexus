GM.Name 	= "Nexus"
GM.Author 	= "GModCoders"
GM.Email 	= "N/A"
GM.Website 	= "glua.me"
GM.Path 	= "gamemodes/nexus/gamemode"

DeriveGamemode("sandbox")

nx = nx or {}

function GM:Initialize()
	self.BaseClass.Initialize( self )
end
