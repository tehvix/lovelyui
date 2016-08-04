

	local BACKDROP = {
		bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
		insets = {left = -3, right = -3, top = -3, bottom = -3}
	}
	local TEXTURE  = [[Interface\AddOns\lovelyui\art\statusbar]]
	local _, class = UnitClass'player'
	local colour   = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

	PaperDollTitlesPane:SetSize(160, 245)
	PaperDollTitlesPane:ClearAllPoints()
	PaperDollTitlesPane:SetPoint('CENTER', CharacterFrameInsetRight, -10, -30)
	PaperDollTitlesPane:EnableMouseWheel(true)

	local bu = PaperDollTitlesPane.buttons
	for i = 1, #bu do
		if bu[i]:IsShown() then
			for _, v in pairs({bu[i].BgTop, bu[i].BgMiddle, bu[i].BgBottom, bu[i].SelectedBar}) do v:SetAlpha(0) end
			bu[i]:SetWidth(160)
		end
	end

	local titles = function()
		for i = 1, #bu do bu[i].Stripe:Hide() end
	end

	hooksecurefunc('PaperDollTitlesPane_UpdateScrollFrame', titles)
	PaperDollTitlesPane:HookScript('OnMouseWheel', titles)

	--
