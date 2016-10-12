local meta = FindMetaTable("Player")

function meta:inEvent()
	return ndoc.table.nxPEvents[ self:EntIndex() ]
end