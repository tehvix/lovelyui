

	local LOVELY_PAPERDOLL_STATCATEGORIES = {
		stats = {
			[1]  = {stat = 'STRENGTH',  primary = LE_UNIT_STAT_STRENGTH},
			[2]  = {stat = 'AGILITY',   primary = LE_UNIT_STAT_AGILITY},
			[3]  = {stat = 'INTELLECT', primary = LE_UNIT_STAT_INTELLECT},
			[4]  = {stat = 'STAMINA'},
			[5]  = {stat = 'ARMOR'},
			[6]  = {stat = 'MANAREGEN',               roles =  {'HEALER'}},
			[7]  = {stat = 'CRITCHANCE',  hideAt = 0},
			[8]  = {stat = 'HASTE',       hideAt = 0},
			[9]  = {stat = 'MASTERY',     hideAt = 0},
			[10] = {stat = 'VERSATILITY', hideAt = 0},
			[11] = {stat = 'LIFESTEAL',   hideAt = 0},
			[12] = {stat = 'AVOIDANCE',   hideAt = 0},
			[13] = {stat = 'DODGE',                   roles =  {'TANK'}},
			[14] = {stat = 'PARRY',       hideAt = 0, roles =  {'TANK'}},
			[15] = {stat = 'BLOCK',       hideAt = 0, roles =  {'TANK'}},
		},
	}

	local stats = function()
		CharacterStatsPane.statsFramePool:ReleaseAll()
		local f = CharacterStatsPane.statsFramePool:Acquire()
		local last
		local spec = GetSpecialization()
		local role = GetSpecializationRole(spec)
		local cf   = CharacterStatsPane.AttributesCategory
		local num  = 0

		if  CharacterStatsPane.ItemLevelFrame:IsShown() then
			CharacterStatsPane.ItemLevelFrame.Background:Hide()
		end

		for i = 1, #LOVELY_PAPERDOLL_STATCATEGORIES.stats do
			local stat = LOVELY_PAPERDOLL_STATCATEGORIES.stats[i]
			local show = true
			if show and stat.primary then
				local primary = select(7, GetSpecializationInfo(spec, nil, nil, nil, UnitSex'player'))
				if stat.primary ~= primary then show = false end
			end
			if show and stat.roles then
				local found = false
				for _, roles in pairs(stat.roles) do
					if role == role then found = true break end
				end
				show = found
			end
			if show then
				f.onEnterFunc = nil
				PAPERDOLL_STATINFO[stat.stat].updateFunc(f, 'player')
				if not stat.hideAt or stat.hideAt ~= f.numericValue then
					if num == 0 then
						if last then
							cf:SetPoint('TOP', last, 'BOTTOM', 0, -5)
						end
						last = cf
						f:SetPoint('TOPRIGHT', _G['modCharacterScene'], 'BOTTOMRIGHT', 4, -4)
					else
						f:SetPoint('TOP', last, 'BOTTOM')
					end
					num = num + 1
					last = f
					f:SetWidth(205)
					f.Background:Hide()
					f = CharacterStatsPane.statsFramePool:Acquire()
				end
			end
		end
		cf:SetShown(num > 0)
		CharacterStatsPane.statsFramePool:Release(f)
	end

	CharacterStatsPane.EnhancementsCategory:DisableDrawLayer'BACKGROUND'
	CharacterStatsPane.EnhancementsCategory.Title:SetText''

	CharacterStatsPane.AttributesCategory:ClearAllPoints()
	CharacterStatsPane.AttributesCategory:SetPoint('BOTTOM', CharacterStatsPane)
	CharacterStatsPane.AttributesCategory:DisableDrawLayer'BACKGROUND'
	CharacterStatsPane.AttributesCategory.Title:SetText''

	CharacterStatsPane.ItemLevelCategory:DisableDrawLayer'BACKGROUND'
	CharacterStatsPane.ItemLevelCategory:ClearAllPoints()
	CharacterStatsPane.ItemLevelCategory:SetPoint('TOP', 4, -4)
	CharacterStatsPane.ItemLevelCategory.Title:ClearAllPoints()
	CharacterStatsPane.ItemLevelCategory.Title:SetPoint('TOP', 0, -60)

	CharacterStatsPane.ItemLevelFrame:SetSize(190, 130)
	CharacterStatsPane.ItemLevelFrame:ClearAllPoints()
	CharacterStatsPane.ItemLevelFrame:SetPoint('TOP', 4, -45)
	CharacterStatsPane.ItemLevelFrame.Background:SetAtlas''
	CharacterStatsPane.ItemLevelFrame.Value:SetFont(STANDARD_TEXT_FONT, 45)

	hooksecurefunc('PaperDollFrame_UpdateStats', stats)


	--
