nx.config = nx.config or {}

--how often should payroll be issued? seconds
nx.config.payrollTime = 60
--should payroll be deducted from the faction bank?
nx.config.useFactionBank = true
--should the boss have powers, allowing them to demote and remove without votes?
nx.config.bossPowers = true
--how many slots should the player get for default in their inventory?
nx.config.defaultInvSlots = 10
--should faction currency persist over restart?
nx.config.factionBankPersist = true
--should the physgun color be set as the faction's color?
nx.config.physgunColorFactionColor = true
--how many points does a faction need to capture a zone
nx.config.zoneCaptureScore = 100
--every <x> seconds score is added to the faction in control
nx.config.zoneCaptureRate =  1
-- what portion of the real weapon value should shipments cost
-- shipmentCount * singlePrice * nx.config.shipmentMarkdown
nx.config.shipmentMarkdown = 0.80
--how many guns are in a shipment by default
nx.config.defaultShipmentCount = 10
--which tools should we ignore when checking if a player can use it?
nx.config.whitelisted_tools = {
	['fw_zone_creator'] = true, -- leave this here or you won't be able to create zones!
	['fw_object_creator'] = true,
}