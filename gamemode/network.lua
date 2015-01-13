network = {}
network.__index = network

local nets = {}

function network.new(sName)
	if !nets[sName] then
		if SERVER then
			util.AddNetworkString(sName)
		end
		nets[sName] = {}
	end
	nets[sName].stream = {}
	nets[sName].name = sName
	setmetatable(nets[sName],network)
	return nets[sName]
end
function network.reader(sName)
	return setmetatable({name = sName},network)
end
function network:listen(func)
	net.Receive(self.name,func)
end
function network:write(content,bits)
	table.insert(self.stream,{content = content, bits = bits})
	return self
end
function network:send(to)
	local send = net.Send
	if !to and CLIENT then
		send = net.SendToServer
	end
	net.Start(self.name)
	for i=1,#self.stream do
		local obj = self.stream[i]['content']
		local bits = self.stream[i]['bits']
		if isnumber(obj) and bits then
			if bits < 0 then
				net.WriteInt(obj,bits*-1)
			else
				net.WriteUInt(obj,bits)
			end
		elseif IsColor(obj) then
			net.WriteColor(obj)
		elseif istable(obj) then
			net.WriteTable(obj)
		elseif isentity(obj) then
			net.WriteEntity(obj)
		elseif isvector(obj) then
			net.WriteVector(obj)
		elseif isbool(obj) then
			net.WriteBool(obj)
		elseif isangle(obj) then
			net.WriteAngle(obj)
		else
			net.WriteString(tostring(obj))
		end
	end
	send(to)
end

debug.getregistry().Network = network