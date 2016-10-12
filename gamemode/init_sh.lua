require "ra"
--require "spon"

DeriveGamemode("sandbox")

local function load()

nx = {
	debug = true
}


-- gamemode variables
(GM or GAMEMODE).Name = "Nexus"
(GM or GAMEMODE).CondensedName = "nx"
(GM or GAMEMODE).Author = "thelastpenguin, Mikey Howell, Spai, crazyscouter, meharryp, sanny, krekeris, Google, Nak"
(GM or GAMEMODE).Email = ""
(GM or GAMEMODE).Website = "https://github.com/Nexus"
(GM or GAMEMODE).Version = "0.1.0 Alpha"

-- utils
local resolvePath = function(fn)
	local function resolvePathHelper(stackdepth, path)
		if file.Exists(path, "LUA") then return path end
		local info = debug.getinfo(stackdepth, "S").short_src
		info = info:sub(info:find("/") + 1) -- strip off the first /
		info = ra.path.normalize(ra.path.getFolder(info) .. "/" .. path)
		if file.Exists(info, "LUA") then return info end
		return path
	end
	return function(...)
		return fn(resolvePathHelper(3, ...))
	end
end
nx.include_sv = resolvePath(ra.include_sv)
nx.include_cl = resolvePath(ra.include_cl)
nx.include_sh = resolvePath(ra.include_sh)

nx.print = ra.print


-- module loader
print "--------------------------"
print " Nexus v0.1.0 Alpha "
print "--------------------------"

nx.module_srcs = {}
nx.loaded_modules = {}
nx.module_search_paths = {
	(GM or GAMEMODE).FolderName .. "/gamemode/libraries",
	(GM or GAMEMODE).FolderName .. "/gamemode/core",
	(GM or GAMEMODE).FolderName .. "/gamemode/plugins",
	"nx_plugins",
}

-- nx.dep with printing
-- nx.dep(cond:bool, name:string)
-- @param cond:bool - if true then it loads, if false then it doesnt i.e. nx.dep(SERVER, ...)
-- @param name:string - the name of the module to load i.e. hooks
-- @ret module:table - the module's method table
function nx.dep(cond, name)
	if nx.loaded_modules[name] then return nx[name] end

	if not cond then return end

	if not nx.module_srcs[name] then error("no such module \'" .. name .. "\'") end

	Msg(" - [module] " .. name)
	Msg(" " .. string.rep(".", 30 - name:len()) .. " ")
	MsgC(Color(255, 155, 0), "loading\n")

	local ret = include(nx.module_srcs[name])
	if ret then nx[name] = ret end

	Msg(" - [module] " .. name)
	Msg(" " .. string.rep(".", 30 - name:len()) .. " ")
	MsgC(Color(0, 255, 0), "OK\n")

	nx.loaded_modules[name] = true

	return nx[name]
end

SHARED = true

print "Search Paths: "
for k,v in ipairs(nx.module_search_paths) do
	print(" - " .. v)
end

print "Modules: "

nx.include_sv "custom_things/_config_sv.lua"
nx.include_sh "custom_things/_config_sh.lua"
nx.include_cl "custom_things/_config_cl.lua"
nx.include_sh "libraries/spon.lua"

for _, searchPath in ipairs(nx.module_search_paths) do
	local _, directories = file.Find(searchPath.. "/*", "LUA")
	for k, dir in ipairs(directories) do
		nx.module_srcs[dir] = searchPath .. "/" .. dir .. "/module.lua"
	end
end

-- call dep on every module
for k,v in pairs(nx.module_srcs) do
	if not nx[k] then
		nx.dep(SHARED, k)
	end
end


-- nx.dep without printing for things that get loaded later
function nx.dep(name)
	if nx.loaded_modules[name] then return nx[name] end
	nx.loaded_modules[name] = true
	nx[name] = include(nx.module_srcs[name])
	return nx[name]
end

-- todo crawler
if nx.debug then
	print "--------------------------"
	print " Nexus todo list    "
	print "--------------------------"
	local function todoFinder(directory)
		local files, directories = file.Find(directory .. "/*", "LUA")
		for k,v in ipairs(files) do
			local data = file.Read(directory .. "/" .. v, "LUA")
			if (not data) then continue end
			for k, line in ipairs(string.Explode("\n", data)) do
				if line and line:find("--") and line:find("TODO") then
					MsgC(color_white, directory .. "/" .. v .. ":" .. k)
					local start = string.find(line, "TODO") + 4
					MsgN(string.sub(line, start))
				end
			end
		end

		for k,v in ipairs(directories) do
			todoFinder(directory .. "/" .. v)
		end
	end

	for k,v in ipairs(nx.module_search_paths) do
		todoFinder(v)
	end
end

if SERVER then
	RunConsoleCommand("sbox_godmode", "0")
end

end load() -- local function load()


-- allow for reloading
concommand.Add("nx_reload", function(pl)
	if IsValid(pl) and not pl:IsSuperAdmin() then pl:ChatPrint("insufficient privliages") return end
	load()

	nx.hook.Call("Initialize")
	for k, pl in ipairs(player.GetAll()) do
		hook.Call("PlayerInitialSpawn", pl)
		hook.Call("PlayerSpawn", pl)
	end

end)

concommand.Add("nx_reloadmap", function(pl)
	if IsValid(pl) and not pl:IsSuperAdmin() then pl:ChatPrint("insufficient privliages") return end
	nx.print("Reloading map...")
	RunConsoleCommand("changelevel", game.GetMap())
end )
