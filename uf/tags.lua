

local siValue = function(value)
	if not value then return '' end
	local absvalue = abs(value)
	local str, val

	if absvalue >= 1e10 then
		str, val = "%.0fb", value / 1e9
	elseif absvalue >= 1e9 then
		str, val = "%.1fb", value / 1e9
	elseif absvalue >= 1e7 then
		str, val = "%.1fm", value / 1e6
	elseif absvalue >= 1e6 then
		str, val = "%.2fm", value / 1e6
	elseif absvalue >= 1e5 then
		str, val = "%.0fk", value / 1e3
	elseif absvalue >= 1e3 then
		str, val = "%.1fk", value / 1e3
	else
		str, val = "%d", value
	end

	return format(str, val)
end

local tags = oUF.Tags.Methods or oUF.Tags
local tagevents = oUF.TagEvents or oUF.Tags.Events

tags['mod:health'] = function(unit)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	if not UnitIsFriend('player', unit) then
		return siValue(min)
	elseif(min ~= 0 and min ~= max) then
		return '-' .. siValue(max - min)
	else
		return siValue(max)
	end
end
tagevents['mod:health'] = tagevents.missinghp

tags['mod:power'] = function(unit)
	local min, max = UnitPower(unit), UnitPowerMax(unit)
	if(min == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then return end
	return siValue(min)
end
tagevents['mod:power'] = tagevents.missingpp
