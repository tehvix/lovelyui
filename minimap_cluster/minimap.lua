

	local BACKDROP = {
		bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
		tiled = false,
		insets = {left = -3, right = -3, top = -3, bottom = -3}
	}
	local TEXTURE = [[Interface\AddOns\lovelyui\art\statusbar.tga]]

	local _, class = UnitClass'player'
	local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

	local xp = CreateFrame'StatusBar'
	xp:SetHeight(5)
	xp:SetPoint('BOTTOMLEFT',  ObjectiveTrackerFrame, 'TOPLEFT', 5, 15)
	xp:SetPoint('BOTTOMRIGHT', ObjectiveTrackerFrame, 'TOPRIGHT', -5, 15)
	xp:SetStatusBarTexture(TEXTURE)
	xp:SetStatusBarColor(120/255, 88/255, 237/255)
	xp:SetFrameLevel(10)
	xp:EnableMouse(false)

	local header = xp:CreateFontString(nil, 'ARTWORK')
	header:SetFont(STANDARD_TEXT_FONT, 13)
	header:SetShadowOffset(.7, -.7)
	header:SetShadowColor(0, 0, 0, 1)
	header:SetTextColor(1, .8, 0)
	header:SetPoint('TOPRIGHT', ObjectiveTrackerFrame, -25, 50)
	header:SetJustifyH'RIGHT'
	header:SetText'Experience'

	local artifact = CreateFrame'StatusBar'
	artifact:SetHeight(5)
	artifact:SetPoint('BOTTOMLEFT',  ObjectiveTrackerFrame, 'TOPLEFT', 5, 5)
	artifact:SetPoint('BOTTOMRIGHT', ObjectiveTrackerFrame, 'TOPRIGHT', -5, 5)
	artifact:SetStatusBarTexture(TEXTURE)
	artifact:SetStatusBarColor(230/255, 204/255, 128/255)
	artifact:SetBackdrop(BACKDROP)
	artifact:SetBackdropColor(0, 0, 0)
	artifact:SetFrameLevel(10)
	artifact:EnableMouse(false)
	artifact:Hide()

	local rest = CreateFrame('StatusBar', nil, xp)
	rest:SetHeight(5)
	rest:SetPoint('BOTTOMLEFT',  ObjectiveTrackerFrame, 'TOPLEFT', 5, 15)
	rest:SetPoint('BOTTOMRIGHT', ObjectiveTrackerFrame, 'TOPRIGHT', -5, 15)
	rest:SetStatusBarTexture(TEXTURE)
	rest:SetStatusBarColor(157/255, 187/255, 244/255)
	rest:SetBackdrop(BACKDROP)
	rest:SetBackdropColor(0, 0, 0)
	rest:SetFrameLevel(9)
	rest:EnableMouse(false)

	xp.data = xp:CreateFontString(nil, 'OVERLAY')
	xp.data:SetFont([[Fonts\ARIALN.ttf]], 9)
	xp.data:SetSpacing(4)
	xp.data:SetShadowOffset(1.5, -1)
	xp.data:SetShadowColor(0, 0, 0, 1)
	xp.data:SetPoint('RIGHT', xp, 'LEFT', -14, 2)
	xp.data:Hide()

	artifact.data = artifact:CreateFontString(nil, 'OVERLAY')
	artifact.data:SetFont([[Fonts\ARIALN.ttf]], 9)
	artifact.data:SetSpacing(4)
	artifact.data:SetShadowOffset(1.5, -1)
	artifact.data:SetShadowColor(0, 0, 0, 1)
	artifact.data:SetPoint('RIGHT', artifact, 'LEFT', -14, -2)
	artifact.data:Hide()

	MinimapCluster:HookScript('OnEnter', function()
		if UnitLevel'player' ~= MAX_PLAYER_LEVEL then
			xp.data:Show() artifact:Show() artifact.data:Show()
		end
	end)

	MinimapCluster:HookScript('OnLeave', function()
		if UnitLevel'player' ~= MAX_PLAYER_LEVEL then
			xp.data:Hide() artifact:Hide() artifact.data:Hide()
		end
	end)

	local xp_update = function()
		local XP, max = UnitXP'player', UnitXPMax'player'
		local percent = math.ceil(XP/max*100)
		local REST    = GetXPExhaustion()

		if UnitLevel'player' == MAX_PLAYER_LEVEL then
			xp:Hide() rest:Hide() header:SetText'Artifact' artifact:Show()
		else
			xp:SetMinMaxValues(min(0, XP), max)
			xp:SetValue(XP)
			rest:SetMinMaxValues(min(0, XP), max)
			rest:SetValue(REST and (XP + REST) or 0)
			xp.data:SetFormattedText(percent..'%% xp')
		end
	end

	local artifact_update = function(self, event)
		local id, altid, name, icon, total, spent, q = C_ArtifactUI.GetEquippedArtifactInfo()
		if HasArtifactEquipped() then
			local num, XP, next = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(spent, total)
			local percent       = math.ceil(XP/next*100)
			artifact:SetMinMaxValues(0, next)
			artifact:SetValue(XP)
			artifact.data:SetFormattedText(percent..'%% ap — points to spend: '..num)
		end
		if event == 'ARTIFACT_XP_UPDATE' then
			if not artifact:IsShown() then
				artifact:Show()
				artifact.data:Show()
				C_Timer.After(7, function() artifact:Hide() end)
			end
		end
	end

	artifact:SetScript('OnShow', artifact_update)

	local f = CreateFrame'Frame'
	f:RegisterEvent'PLAYER_LEVEL_UP'
	f:RegisterEvent'PLAYER_XP_UPDATE'
	f:RegisterEvent'UPDATE_EXHAUSTION'
	f:RegisterEvent'PLAYER_ENTERING_WORLD'
	f:SetScript('OnEvent', xp_update)
	local f2 = CreateFrame'Frame'
	f2:RegisterEvent'ARTIFACT_XP_UPDATE'
	f2:SetScript('OnEvent', artifact_update)

	local bo = CreateFrame('Frame', 'modminimap', UIParent)
	bo:SetSize(70, 70)
	bo:SetBackdrop({bgFile = [[Interface\AddOns\lovelyui\minimap_cluster\hex2.tga]],
					tiled = false,
					insets = {left = -4, right = -4, top = -4, bottom = -4}})
	bo:SetBackdropColor(0, 0, 0)
	bo:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOM', -150, 147)

	Minimap:SetParent(bo)
	Minimap:SetSize(70, 70)
	Minimap:SetMaskTexture[[Interface\AddOns\lovelyui\minimap_cluster\hex2.tga]]
	Minimap:ClearAllPoints()
	Minimap:SetAllPoints(bo)

	function GetMinimapShape() return 'SQUARE' end

		-- click functionality
	Minimap:SetScript('OnMouseUp', function(self, button)
		Minimap:StopMovingOrSizing()
	    if button == 'RightButton' then
	        ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, - (Minimap:GetWidth() * .7), -3)
	    elseif button == 'MiddleButton' then
	        ToggleCalendar()
	    else
	        Minimap_OnClick(self)
	    end
	end)

		-- scrolling zoom
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript('OnMouseWheel', function(self, arg1)
		if arg1 > 0 then Minimap_ZoomIn() else Minimap_ZoomOut() end
	end)

		-- calendar
	SlashCmdList['CALENDAR'] = function() ToggleCalendar() end
	SLASH_CALENDAR1 = '/cl'
	SLASH_CALENDAR2 = '/calendar'

	MinimapBackdrop:Hide()
	MinimapBorder:Hide()
	MinimapBorderTop:Hide()
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()
	MiniMapVoiceChatFrame:Hide()
	GameTimeFrame:Hide()
	MinimapZoneTextButton:Hide()
	MiniMapTracking:Hide()
	MiniMapMailBorder:Hide()
	MinimapNorthTag:SetAlpha(0)
	MiniMapInstanceDifficulty:SetAlpha(0)
	GuildInstanceDifficulty:SetAlpha(0)
	Minimap:SetArchBlobRingScalar(0)
	Minimap:SetArchBlobRingAlpha(0)
	Minimap:SetQuestBlobRingScalar(0)
	Minimap:SetQuestBlobRingAlpha(0)

		-- clock
	LoadAddOn'Blizzard_TimeManager'
	local region = TimeManagerClockButton:GetRegions()
	region:Hide()
	TimeManagerClockButton:Hide()

		-- button alerts
	local lfg  = QueueStatusMinimapButton
	local mail = MiniMapMailFrame

	for  i, v in pairs({mail, lfg}) do
		local sort = function()
			v:SetParent(Minimap)
			v:SetFrameStrata'High'
			v:ClearAllPoints()
			if i == 1 then
				v:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', 0, 6)
			else
				v:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', 0, -6*(i - 1))
			end
		end
		v:HookScript('OnShow', sort)
		v:HookScript('OnHide', sort)
	end

	lfg.t = lfg:CreateFontString(nil, 'OVERLAY')
	lfg.t:SetFont([[Fonts\ARIALN.ttf]], 9)
	lfg.t:SetPoint('TOPLEFT', lfg)
	lfg.t:SetTextColor(1, 1, 1)
	lfg.t:SetShadowOffset(1, -1)
	lfg.t:SetShadowColor(0, 0, 0, 1)
	lfg.t:SetJustifyH'LEFT'
	lfg.t:SetText'In  LFG'

	mail.t = mail:CreateFontString(nil, 'OVERLAY')
	mail.t:SetFont([[Fonts\ARIALN.ttf]], 9)
	mail.t:SetPoint('TOPLEFT', mail)
	mail.t:SetTextColor(1, 1, 1)
	mail.t:SetShadowOffset(1, -1)
	mail.t:SetShadowColor(0, 0, 0, 1)
	mail.t:SetJustifyH'LEFT'
	mail.t:SetText'Got  Post'

	QueueStatusMinimapButtonBorder:SetTexture''
	MiniMapMailIcon:SetTexture''

		-- garrison
	for _, v in pairs({GarrisonLandingPageMinimapButton:GetRegions()}) do v:Hide() end
	GarrisonLandingPageMinimapButton:SetScale(.725)
	GarrisonLandingPageMinimapButton:SetParent(Minimap)
	GarrisonLandingPageMinimapButton:ClearAllPoints()
	GarrisonLandingPageMinimapButton:SetFrameStrata('HIGH')
	GarrisonLandingPageMinimapButton:SetPoint('RIGHT', GameTimeFrame, 'LEFT', 15.2, 17.2)

	    -- WORLD STATE CAP BAR
	hooksecurefunc('UIParent_ManageFramePositions', function()
	    if NUM_EXTENDED_UI_FRAMES then
	        for i = 1, NUM_EXTENDED_UI_FRAMES do
	            local bar = _G['WorldStateCaptureBar'..i]
	            if bar and bar:IsVisible() then
	                bar:ClearAllPoints()
	                if i == 1 then
	                    bar:SetPoint('TOP', MinimapCluster, 'BOTTOM', 5, -30)
	                else
	                    bar:SetPoint('TOP', _G['WorldStateCaptureBar'..(i - 1)], 'BOTTOM', 0, -20)
	                end
	            end
	        end
	    end
	end)


	    -- DURABILITY
	hooksecurefunc(DurabilityFrame, 'SetPoint', function(self, _, parent)
	    if parent == 'MinimapCluster' or parent == _G['MinimapCluster'] then
	        self:ClearAllPoints()
			self:SetPoint('LEFT', Minimap, 'RIGHT', -38, 45)
			self:SetScale(.55)
			self:SetParent(Minimap)
		end
	end)


	    -- VEHICLE SEAT INDICATOR
	hooksecurefunc(VehicleSeatIndicator,'SetPoint', function(self, _, parent)
	    if parent=='MinimapCluster' or parent==_G['MinimapCluster'] then
		    self:ClearAllPoints()
		    self:SetPoint('TOP', Minimap, 'BOTTOM', -100, 50)
		    self:SetScale(.7)
	    end
	end)

	    -- TEXT STRINGS
	    -- raid warning, boss emotes, zone text
	RaidWarningFrame:SetWidth(360)
	RaidWarningFrameSlot1:SetWidth(444)
	RaidWarningFrameSlot1:SetFont(STANDARD_TEXT_FONT, 30, 'OUTLINE')
	RaidWarningFrameSlot1:SetShadowOffset(0, -0)
	RaidWarningFrameSlot1:SetAlpha(.7)
	RaidWarningFrameSlot2:SetWidth(444)
	RaidWarningFrameSlot2:SetFont(STANDARD_TEXT_FONT, 30, 'OUTLINE')
	RaidWarningFrameSlot2:SetShadowOffset(0, -0)
	RaidWarningFrameSlot2:SetAlpha(.7)
	RaidBossEmoteFrameSlot1:SetWidth(444)
	RaidBossEmoteFrameSlot1:SetFont(STANDARD_TEXT_FONT, 30, 'OUTLINE')
	RaidBossEmoteFrameSlot1:SetShadowOffset(0, -0)
	RaidBossEmoteFrameSlot1:SetAlpha(.7)
	RaidBossEmoteFrameSlot2:SetWidth(444)
	RaidBossEmoteFrameSlot2:SetFont(STANDARD_TEXT_FONT, 30, 'OUTLINE')
	RaidBossEmoteFrameSlot2:SetShadowOffset(0, -0)
	RaidBossEmoteFrameSlot2:SetAlpha(.7)
	RaidWarningFrame.timings.RAID_NOTICE_MIN_HEIGHT = 30
	RaidBossEmoteFrame.timings.RAID_NOTICE_MIN_HEIGHT = 30
	ObjectiveFont:SetFont(STANDARD_TEXT_FONT, 13)

	ZoneTextString:SetFont('Fonts\\skurri.ttf', 13)
	ZoneTextString:SetShadowOffset(1, -1.25)
	ZoneTextString:SetShadowColor(0, 0, 0, 1)
	SubZoneTextString:SetFont('Fonts\\skurri.ttf', 13)
	SubZoneTextString:SetShadowOffset(1, -1.25)
	SubZoneTextString:SetShadowColor(0, 0, 0, 1)
	PVPInfoTextString:SetFont('Fonts\\skurri.ttf', 13)
	PVPInfoTextString:SetShadowOffset(1, -1.25)
	PVPInfoTextString:SetShadowColor(0, 0, 0, 1)
	PVPArenaTextString:SetFont('Fonts\\skurri.ttf', 13)
	PVPArenaTextString:SetShadowOffset(1, -1.25)
	PVPArenaTextString:SetShadowColor(0, 0, 0, 1)

	local sub = CreateFrame('Frame', nil, SubZoneTextFrame)
	sub:ClearAllPoints()
	sub:SetPoint('TOP', SubZoneTextString, 0, 6)
	sub:SetPoint('BOTTOM', SubZoneTextString, 0 ,-6)
	sub:SetHeight(30)

	hooksecurefunc('SetZoneText', function(show)
		ZoneTextFrame:Hide()
		PVPInfoTextString:Hide()
		PVPArenaTextString:Hide()
		PVPInfoTextString:Hide()

		sub:SetWidth(SubZoneTextString:GetStringWidth() + 16)
		SubZoneTextFrame:ClearAllPoints()
		SubZoneTextFrame:SetParent(UIParent)

		SubZoneTextString:SetJustifyH'LEFT'
		PVPInfoTextString:SetJustifyH'LEFT'

		if not show then
			PVPInfoTextString:SetText''
			SubZoneTextFrame:SetPoint('CENTER', UIParent, -18, 40)
		end

		if  PVPInfoTextString:GetText() == '' then
			SubZoneTextFrame:SetPoint('CENTER', UIParent, -18, 40)
		else
			SubZoneTextString:SetPoint('TOPLEFT', 'PVPInfoTextString', 'BOTTOMLEFT', 0, -2)
			PVPInfoTextString:ClearAllPoints()
			PVPInfoTextString:SetPoint('CENTER', UIParent, -18, 40)
		end
	end)
