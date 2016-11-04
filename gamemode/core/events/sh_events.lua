local meta = FindMetaTable("Player")

function meta:inEvent()
	return ndoc.table.nxPEvents[ self:EntIndex() ]
end

function nx.events.canCreateEvent(...)
	return true
end