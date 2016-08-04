
	local _, ns = ...

	local BACKDROP = {
		bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
		insets = {left = -3, right = -3, top = -3, bottom = -3}
	}
	local TEXTURE  = [[Interface\AddOns\lovelyui\art\statusbar]]
	local _, class = UnitClass'player'
	local colour   = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

	PaperDollEquipmentManagerPane:SetSize(160, 245)
	PaperDollEquipmentManagerPane:ClearAllPoints()
	PaperDollEquipmentManagerPane:SetPoint('CENTER', CharacterFrameInsetRight, -10, -30)

	PaperDollEquipmentManagerPane.EquipSet.ButtonBackground:Hide()

	for _, v in pairs({PaperDollEquipmentManagerPaneEquipSet, PaperDollEquipmentManagerPaneSaveSet}) do
		ns.button(v)
	end

	local bu = PaperDollEquipmentManagerPane.buttons
	for i = 1, #bu do
		if bu[i]:IsShown() then
			for _, v in pairs({bu[i].BgTop, bu[i].BgMiddle, bu[i].BgBottom, bu[i].HighlightBar, bu[i].SelectedBar}) do v:SetAlpha(0) end
			bu[i]:SetWidth(160)
		end
	end

	local button = function()
		local offset = HybridScrollFrame_GetOffset(PaperDollEquipmentManagerPane)
		local num    = GetNumEquipmentSets()
		for i = 1, #bu do
			bu[i].Stripe:Hide()
			if i + offset <= num then
				bu[i].icon:SetTexCoord(.1, .9, .1, .9)
				bu[i].icon:SetSize(24, 24)
				if not bu[i].icon.bg then
					bu[i].icon.bg = CreateFrame('Frame', nil, bu[i])
					bu[i].icon.bg:SetAllPoints(bu[i].icon)
					bu[i].icon.bg:SetBackdrop(BACKDROP)
					bu[i].icon.bg:SetBackdropColor(0, 0, 0)
					bu[i].icon.bg:SetFrameLevel(0)
				end
			end
		end
	end

	hooksecurefunc('PaperDollEquipmentManagerPane_Update', button)
	PaperDollEquipmentManagerPane:HookScript('OnMouseWheel', button)

	--
