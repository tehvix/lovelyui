

	local BACKDROP = {
		bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
		insets = {left = -3, right = -3, top = -3, bottom = -3}
	}

		-- loot
	for i = 1, 4 do
		local bu = _G['LootButton'..i]
		local qu = _G['LootButton'..i..'IconQuestTexture']
        local ic = _G['LootButton'..i..'IconTexture']
        local ct = _G['LootButton'..i..'Count']
		local bg = _G['LootButton'..i..'NameFrame']
		if bu then
			bu:SetSize(24, 24)
			bu:SetBackdrop(BACKDROP)
			bu:SetBackdropColor(0, 0, 0, 1)
			bu:SetNormalTexture''
			bu:SetPushedTexture''

			ic:SetTexCoord(.1, .9, .1, .9)

			ct:SetDrawLayer('OVERLAY', 7)
            ct:SetJustifyH'CENTER'
            ct:ClearAllPoints()
            ct:SetPoint('CENTER', ic, 'BOTTOM', 1, 0)

			bg:SetAlpha(0)
			if qu then qu:SetSize(1, 1) qu:SetDrawLayer'BACKGROUND' end
		end
	end
