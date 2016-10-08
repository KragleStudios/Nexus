
util.AddNetworkString("nx.notif.conprint")
util.AddNetworkString("nx.notif.chatprint")
util.AddNetworkString("nx.notif.banner")
util.AddNetworkString("nx.notif.chat")

local Player = FindMetaTable("Player")

local net = net 

local function sendHelper(a, ...)
	if a == nil then return net.WriteUInt(0, 2) end
	if type(a) == "table" then 
		net.WriteUInt(1, 2)
		net.WriteUInt(a.r, 8)
		net.WriteUInt(a.g, 8)
		net.WriteUInt(a.b, 8)
	elseif type(a) == "string" then
		net.WriteUInt(2, 2)
		net.WriteString(tostring(a))
	end
	sendHelper(...)
end

local function fwConPrint(players, ...)
	net.Start("nx.notif.conprint")
		sendHelper(...)
	net.Send(players)
end

local function fwChatPrint(players, ...)
	net.Start("nx.notif.chatprint")
		sendHelper(...)
	net.Send(players)
end

local function fwChatComm(players, ...)
	net.Start("nx.notif.chat")
		sendHelper(...)
	net.Send(players)
end

nx.notif.chat = fwChatComm

nx.notif.chatPrint = fwChatPrint
nx.notif.conPrint = fwConPrint

function Player:FWConPrint(...)
	fwConPrint(self, ...)
end

function Player:FWChatPrint(...)
	fwChatPrint(self, ...) 
end

function Player:FWChatPrintError(...)
	fwChatPrint(self, color_black, "[Error] ", Color(255, 0, 0), ...)
end
