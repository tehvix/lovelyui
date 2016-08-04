

	local BACKDROP = {
		bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
		insets = {left = -3, right = -3, top = -3, bottom = -3}
	}
	local BACKDROP_BORDER = {
		bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
		edgeFile = [[Interface\Buttons\WHITE8x8]],
		tiled = false,
		edgeSize = -3,
		insets = {left = -3, right = -3, top = -3, bottom = -3}
	}

	local TEXTURE  = [[Interface\AddOns\lovelyui\art\statusbar]]
	local _, class = UnitClass'player'
	local color    = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

    for _, v in pairs({CharacterFrame:GetRegions()}) do
		if v:GetObjectType() == 'Texture' then v:Hide() end
    end

	for _, v in pairs({CharacterFrameInset:GetRegions()}) do
		if v:GetObjectType() == 'Texture' then v:Hide() end
    end

	for _, v in pairs({'BACKGROUND', 'BORDER', 'OVERLAY'}) do
		CharacterModelFrame:DisableDrawLayer(v)
	end

	local slots = {
        'Head', 'Neck', 'Shoulder', 'Shirt', 'Chest', 'Waist',
        'Legs', 'Feet', 'Wrist', 'Hands', 'Finger0', 'Finger1',
        'Trinket0', 'Trinket1', 'Back', 'MainHand', 'SecondaryHand', 'Tabard',
    }

	for i = 1, #slots do
		local slot = _G['Character'..slots[i]..'Slot']

		_G['Character'..slots[i]..'SlotFrame']:Hide()

		slot:SetNormalTexture''
		slot:SetPushedTexture''
		slot:SetBackdrop(BACKDROP)
		slot:SetBackdropColor(0, 0, 0)

		slot.IconBorder:SetAlpha(0)

		slot.icon:SetTexCoord(.1, .9, .1, .9)

		slot:SetSize(22, 22)
		slot:ClearAllPoints()
		if i == 1 then
			slot:SetPoint('BOTTOMLEFT', CharacterFrameInset, 0, 33)
		elseif i == 9 then
			slot:SetPoint('TOP', _G['Character'..slots[1]..'Slot'], 'BOTTOM', 0, -3)
		elseif i == 16 then
			slot:SetPoint('BOTTOMRIGHT', CharacterFrameInset, 'BOTTOM', -3, 63)
		elseif i == 18 then
			slot:SetPoint('LEFT', _G['Character'..slots[15]..'Slot'], 'RIGHT', 3, 0)
		else
			slot:SetPoint('LEFT', _G['Character'..slots[i - 1]..'Slot'], 'RIGHT', 3, 0)
		end
	end

	for i = 1, 3 do
		local paperdoll, character = _G['PaperDollSidebarTab'..i], _G['CharacterFrameTab'..i]

		for _, v in pairs({paperdoll, character}) do v:DisableDrawLayer'BACKGROUND' end

		paperdoll:SetSize(20, 20)
		paperdoll:SetHighlightTexture''
		paperdoll:ClearAllPoints()
		if i == 1 then
			paperdoll:SetPoint('BOTTOM', PaperDollSidebarTabs, -23, 0)
		else
			paperdoll:SetPoint('BOTTOMLEFT', _G['PaperDollSidebarTab'..(i - 1)], 'BOTTOMRIGHT')
		end

		paperdoll.bg = CreateFrame('Frame', nil, paperdoll)
		paperdoll.bg:SetPoint('TOPLEFT', -2, 2)
		paperdoll.bg:SetPoint('BOTTOMRIGHT', 2, -2)
		paperdoll.bg:SetFrameLevel(0)
		paperdoll.bg:SetBackdrop(BACKDROP)
		paperdoll.bg:SetBackdropColor(0, 0, 0, 1)
		paperdoll.Icon:SetSize(23, 23)
		paperdoll.Hider:SetAlpha(0)
		paperdoll.TabBg:SetAlpha(0)
		paperdoll.Highlight:SetAlpha(0)
	end

	PaperDollEquipmentManagerPane:SetSize(162, 250)
	PaperDollEquipmentManagerPane:ClearAllPoints()
	PaperDollEquipmentManagerPane:SetPoint('CENTER', CharacterFrameInsetRight, -8, 0)

	PaperDollSidebarTabs:ClearAllPoints()
	PaperDollSidebarTabs:SetPoint('TOP', CharacterFrameInsetRight, 5, 10)
	PaperDollSidebarTabs.DecorLeft:Hide() PaperDollSidebarTabs.DecorRight:Hide()

	select(11, CharacterMainHandSlot:GetRegions()):Hide()
	select(11, CharacterSecondaryHandSlot:GetRegions()):Hide()

	hooksecurefunc('PaperDollFrame_SetLevel', function()
		CharacterLevelText:SetJustifyH'LEFT'
		CharacterLevelText:ClearAllPoints()
 		CharacterLevelText:SetPoint('TOPLEFT', CharacterFrameInset, 12, -14)
	 end)
	hooksecurefunc('CharacterFrame_Collapse', function()
		CharacterFrame:SetSize(200, 315)
	end)
	hooksecurefunc('CharacterFrame_Expand', function()
		CharacterFrame:SetSize(400, 315)
	end)
	CharacterFrame:SetBackdrop(BACKDROP_BORDER)
 	CharacterFrame:SetBackdropColor(0, 0, 0)
	CharacterFrame:SetBackdropBorderColor(0 ,0, 0)

	CharacterFrameInset:ClearAllPoints()
	CharacterFrameInset:SetPoint('BOTTOMLEFT', CharacterFrame)
	CharacterFrameInset:SetSize(200, 315)
	CharacterFrameInset:SetBackdrop(BACKDROP_BORDER)
	CharacterFrameInset:SetBackdropColor(0, 0, 0, 0)
	CharacterFrameInset:SetBackdropBorderColor(0 ,0, 0)

	CharacterFrameInsetRight:SetSize(200, 315)
	CharacterFrameInsetRight:DisableDrawLayer'BACKGROUND'
	for _, v in pairs({CharacterFrameInsetRight:GetRegions()}) do if v:GetObjectType() == 'Texture' then v:Hide() end end

	CharacterModelFrame:SetScale(.64)
	CharacterModelFrame:ClearAllPoints()
	CharacterModelFrame:SetPoint('CENTER', CharacterFrameInset, 0, 33)

	local stats = CreateFrame('Button', nil, CharacterFrameInset)
	stats:SetSize(24, 24)
	stats:SetPoint('BOTTOMRIGHT', CharacterFrameInset, -5, 60)
	stats.t = stats:CreateFontString(nil, 'OVERLAY')
	stats.t:SetPoint'CENTER'
	stats.t:SetJustifyH'CENTER'
	stats.t:SetFont([[Fonts\skurri.ttf]], 15)
	stats.t:SetShadowOffset(1, -1.25)
	stats.t:SetShadowColor(0, 0, 0, 1)
	stats.t:SetTextColor(1, 1, 1)
	--[[stats.t:SetText'<'

	stats:SetScript('OnClick', function()
		if not CharacterFrame.Expanded then
			CharacterFrame_Expand()
			stats.t:SetText'<'
		else
			CharacterFrame_Collapse()
			stats.t:SetText'>'
		end
	end)]]

	CharacterStatsPane:DisableDrawLayer'BACKGROUND'

		local durability = CreateFrame('StatusBar', nil, CharacterFrameInset)
		durability:SetStatusBarTexture(TEXTURE)
		durability:SetHeight(5)
		durability:SetPoint('BOTTOMLEFT',  CharacterFrameInset)
		durability:SetPoint('BOTTOMRIGHT', CharacterFrameInset)
		durability:SetMinMaxValues(0, 100) durability:SetValue(100)
		durability:SetStatusBarTexture(240/255, 215/255, 30/255)
		durability:SetBackdrop(BACKDROP)
		durability:SetBackdropColor(0, 0, 0)

		local tt = CreateFrame('Frame', 'modCharacterScene', CharacterFrame)
		tt:SetSize(400, 130)
		tt:SetPoint('TOPLEFT', CharacterFrame, 0, -44)
		tt:SetBackdrop(BACKDROP_BORDER)
		tt:SetBackdropColor(0, 0, 0)
		tt:SetBackdropBorderColor(0, 0, 0)
		tt:SetFrameLevel(0)

		local faction = UnitFactionGroup'player' == 'Alliance' and 'Valsharah' or 'Suramar'
		tt.t = tt:CreateTexture(nil, 'OVERLAY')
		tt.t:SetAllPoints()
		tt.t:SetAtlas('_GarrMissionLocation-'..faction..'-Back')

		tt.t2 = tt:CreateTexture(nil, 'OVERLAY')
		tt.t2:SetAllPoints()
		tt.t2:SetAtlas('_GarrMissionLocation-'..faction..'-Mid')

		tt.t3 = tt:CreateTexture(nil, 'OVERLAY')
		tt.t3:SetAllPoints()
		tt.t3:SetAtlas('_GarrMissionLocation-'..faction..'-Fore')

		    --parallax rates in % texCoords per second
		local rateBack, rateMid, rateFore = .2, .6, 1.6
		tt:SetScript('OnUpdate', function(self, elapsed)
		    local changeBack = rateBack/100*elapsed
		    local changeMid  = rateMid/100*elapsed
		    local changeFore = rateFore/100 * elapsed

		    local backL, _, _, _, backR = self.t:GetTexCoord()
		    local midL, _, _, _, midR   = self.t2:GetTexCoord()
		    local foreL, _, _, _, foreR = self.t3:GetTexCoord()

		    backL = backL + changeBack
		    backR = backR + changeBack
		    midL = midL + changeMid
		    midR = midR + changeMid
		    foreL = foreL + changeFore
		    foreR = foreR + changeFore

		    if  backL >= 1 then
		    	backL = backL - 1
		    	backR = backR - 1
		    end
		    if  midL >= 1 then
		    	midL = midL - 1
		    	midR = midR - 1
		    end
		    if  foreL >= 1 then
		    	foreL = foreL - 1
		    	foreR = foreR - 1
		    end

		    self.t:SetTexCoord(backL, backR, 0, 1)
		    self.t2:SetTexCoord (midL, midR, 0, 1)
		    self.t3:SetTexCoord(foreL, foreR, 0, 1)
		end)

	--
