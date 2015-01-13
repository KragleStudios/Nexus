GM.Name 	= "Nexus"
GM.Author 	= "GModCoders"
GM.Email 	= "N/A"
GM.Website 	= "glua.me"
GM.Path 	= "gamemodes/nexus/gamemode"

DeriveGamemode("sandbox")

NX = NX or {}

include('network.lua')

function GM:Initialize()
	self.BaseClass.Initialize( self )
end
