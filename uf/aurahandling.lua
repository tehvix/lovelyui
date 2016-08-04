local name, addon = ...

do
	local playerUnits = { player = true, pet = true, vehicle = true, }
	local CustomAuraFilter = {
		target = function(element, unit, icon, name, rank, texture, count, debuffType, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff)
			if icon.isDebuff and not UnitIsFriend('player', unit)
			and not playerUnits[icon.owner] and icon.owner ~= unit then
				return false
			else
				return true
			end
		end
	}
	addon.CustomAuraFilter = CustomAuraFilter
end
