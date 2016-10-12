local meta = FindMetaTable("Player")

if (SERVER) then
	
	function meta:takeNexi(amt)
		self:GetData().nexi = self:GetData().nexi - math.abs(amt)
	end

	function meta:addNexi(amt)
		self:GetData().nexi = self:GetData().nexi + math.abs(amt)
	end

	function meta:setNexi(amt)
		self:GetData().nexi = math.abs(amt)
	end

end

function meta:canAfford(amt)
	return (self:GetData().nexi - math.abs(amt)) >= 0
end

function meta:getNexi()
	return self:GetData().nexi
end