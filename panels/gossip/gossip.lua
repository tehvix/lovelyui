

	local _, ns = ...

	NORMAL_QUEST_DISPLAY =  '|cffffffff%s|r'
	TRIVIAL_QUEST_DISPLAY = '|cffffffff%s (low level)|r'
	IGNORED_QUEST_DISPLAY = '|cff000000%s (ignored)|r'

	local button = function(bu)
		local t = bu:GetText()
		bu:SetSize(155, bu:GetTextHeight() + 2)
		bu:SetText''    bu.t:SetText(t)
	end

	for _, v in pairs({GossipFrame:GetRegions()}) do
		v:Hide()
	end

	for _, v in pairs({GossipFrameInset:GetRegions()}) do
		v:Hide()
	end

	for _, v in pairs({GossipFrameGreetingGoodbyeButton}) do
		ns.button(v)
	end

	GossipFrameGreetingPanel:SetSize(200, 315)

	GossipFrameNpcNameText:SetWidth(140)
	GossipFrameNpcNameText:ClearAllPoints()
	GossipFrameNpcNameText:SetPoint('TOPLEFT', GossipFrame, 14, -4)
	GossipFrameNpcNameText:SetJustifyH'LEFT'

	GossipGreetingText:SetSize(155, 0)
	GossipGreetingText:SetFont(STANDARD_TEXT_FONT, 10)
	GossipGreetingText:SetTextColor(1, 1, 1)

	for i = 1, NUMGOSSIPBUTTONS do
		local bu = _G['GossipTitleButton'..i]
		bu:SetSize(130, 16)
		bu:SetNormalFontObject('GameFontHighlightSmall')
		bu.t = bu:CreateFontString(nil, 'OVERLAY')
		bu.t:SetPoint('LEFT', 30, 0)
		bu.t:SetWidth(130)
		bu.t:SetJustifyH'LEFT'
		bu.t:SetFont([[Fonts\ARIALN.ttf]], 10)
		bu.t:SetShadowOffset(1, -1.25)
		bu.t:SetShadowColor(0, 0, 0, 1)
		bu.t:SetTextColor(1, 1, 1)
	end

	hooksecurefunc('GossipResize', button)

	--
