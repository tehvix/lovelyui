

	local BACKDROP = {
		bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
		insets = {left = -1, right = -1, top = -1, bottom = -1}
	}
	local TEXTURE  = [[Interface\AddOns\lovelyui\art\statusbar]]
	local _, class = UnitClass'player'
	local color    = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

		-- loot
	for i = 1, LootFrame:GetNumRegions() do
		local reg = select(i, LootFrame:GetRegions())
		if reg:GetObjectType() == 'FontString' then reg:SetText'' end
		if reg:GetObjectType() == 'Texture' then
			reg:Hide()
		end
	end

	LootFrameCloseButton:ClearAllPoints() LootFrameCloseButton:SetPoint('TOPLEFT', LootFrame, -22, -61)
	LootFrameCloseButton:SetNormalTexture''
	LootFrameCloseButton.t = LootFrameCloseButton:CreateFontString(nil, 'OVERLAY')
	LootFrameCloseButton.t:SetPoint'CENTER'
	LootFrameCloseButton.t:SetJustifyH'CENTER'
	LootFrameCloseButton.t:SetFont([[Fonts\skurri.ttf]], 15)
	LootFrameCloseButton.t:SetShadowOffset(1, -1.25)
	LootFrameCloseButton.t:SetShadowColor(0, 0, 0, 1)
	LootFrameCloseButton.t:SetTextColor(1, 0, 0)
	LootFrameCloseButton.t:SetText'x'

	LootFrameUpButton:ClearAllPoints()   LootFrameUpButton:SetPoint('TOPLEFT', LootFrame, -22, -81)
	LootFrameUpButton:SetNormalTexture'' LootFrameUpButton:SetPushedTexture''
	LootFrameUpButton.t = LootFrameUpButton:CreateFontString(nil, 'OVERLAY')
	LootFrameUpButton.t:SetPoint'CENTER'
	LootFrameUpButton.t:SetJustifyH'CENTER'
	LootFrameUpButton.t:SetFont([[Fonts\ARIALN.ttf]], 13)
	LootFrameUpButton.t:SetShadowOffset(1, -1.25)
	LootFrameUpButton.t:SetShadowColor(0, 0, 0, 1)
	LootFrameUpButton.t:SetTextColor(1, 1, 1)
	LootFrameUpButton.t:SetText'>'

	LootFrameDownButton:ClearAllPoints()   LootFrameDownButton:SetPoint('TOPLEFT', LootFrame, -22, -81)
	LootFrameDownButton:SetNormalTexture'' LootFrameDownButton:SetPushedTexture''
	LootFrameDownButton.t = LootFrameDownButton:CreateFontString(nil, 'OVERLAY')
	LootFrameDownButton.t:SetPoint'CENTER'
	LootFrameDownButton.t:SetJustifyH'CENTER'
	LootFrameDownButton.t:SetFont([[Fonts\ARIALN.ttf]], 13)
	LootFrameDownButton.t:SetShadowOffset(1, -1.25)
	LootFrameDownButton.t:SetShadowColor(0, 0, 0, 1)
	LootFrameDownButton.t:SetTextColor(1, 1, 1)
	LootFrameDownButton.t:SetText'<'

	LootFrameInset:SetAlpha(0)
