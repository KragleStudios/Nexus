if SERVER then AddCSLuaFile() end

nx.notif = {}

nx.dep(CLIENT, "fonts")

nx.include_cl "notifications_cl.lua"
nx.include_sv "notifications_sv.lua"
nx.include_sh "notifications_sh.lua"
