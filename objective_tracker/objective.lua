

    -- set height of the objective tracker frame.
    local height = 450

    -- set width of the objective tracker frame.
    -- note that this mostly doesn't affect the quest info blocks themselves.
    local width = 188

    -- set font size of objective titles
    local titlesize = 13

    local r, g, b  = 103/255, 103/255, 103/255
    local _, class = UnitClass'player'
    local colour   = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
    local otf      = ObjectiveTrackerFrame

    local BACKDROP = {
    	bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
    	tiled = false,
    	insets = {left = -3, right = -3, top = -3, bottom = -3}
    }
    local BACKDROP_BORDER = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        edgeFile = [[Interface\Buttons\WHITE8x8]],
        tiled = false,
        edgeSize = -3,
        insets = {left = -3, right = -3, top = -3, bottom = -3}
    }
    local TEXTURE  = [[Interface\AddOns\lovelyui\art\statusbar.tga]]


    -- move
    -- http://www.wowinterface.com/forums/showthread.php?t=50666
    local moving
    hooksecurefunc(otf, 'SetPoint', function(self)
        if moving then return end
        moving = true
        self:SetMovable(true)
        self:SetUserPlaced(true)
        self:ClearAllPoints()
        self:SetPoint('TOPRIGHT', UIParent, -35, -80)
        self:SetWidth(width)
        self:SetHeight(height)
        self:SetParent(Minimap) -- Only for default Blizzard unitframes.
        self:SetMovable(false)
        moving = nil
    end)


    -- collapse/expand
    -- in boss fights, arena, capture bar
    -- written with oWatchFrameToggler by haste as a base
    -- https://github.com/haste/oWatchFrameToggler/blob/master/auto.lua
    local otfboss = CreateFrame'Frame'
    otfboss:RegisterEvent'PLAYER_ENTERING_WORLD'
    otfboss:RegisterEvent'INSTANCE_ENCOUNTER_ENGAGE_UNIT'
    otfboss:RegisterEvent'PLAYER_REGEN_ENABLED'
    otfboss:RegisterEvent'UPDATE_WORLD_STATES'

    local function bossexists()
        for i = 1, MAX_BOSS_FRAMES do
            if UnitExists('boss'..i) then
                return true
            end
	    end
    end

    otf.boss = false
    otfboss:SetScript('OnEvent', function(self, event)
        local _, instanceType = IsInInstance()
        local bar = _G['WorldStateCaptureBar1']

        -- collapse if there's a boss
        if event == 'INSTANCE_ENCOUNTER_ENGAGE_UNIT' or bossexists() then
		    if not otf.collapsed then ObjectiveTracker_Collapse() otf.boss = true end
		-- or we're pvping
        elseif instanceType == 'arena' or instanceType == 'pvp' then
            if not otf.collapsed then ObjectiveTracker_Collapse() otf.boss = true end
		    -- or if we get a tracker bar appear.
        elseif event == 'UPDATE_WORLD_STATES' and bar and bar:IsVisible() then
            if not otf.collapsed then ObjectiveTracker_Collapse() otf.boss = true end
		    -- open back up afterward if we're in a raid
	    elseif
            event == 'PLAYER_REGEN_ENABLED'
            and otf.collapsed
            and instanceType == 'raid'
            and otf.boss
        then
		    ObjectiveTracker_Expand()
		    -- or in ashran/wintergrasp/grim batol
        elseif
            otf.collapsed
            and (GetMapNameByID(1191) or GetMapNameByID(4197) or GetMapNameByID(4950))
            and otf.boss
            and not InCombatLockdown()
        then
            ObjectiveTracker_Expand()
        end
    end)

    local min = otf.HeaderMenu.MinimizeButton
    min:SetSize(15, 15)
    min:SetNormalTexture''
    min:SetPushedTexture''

    min.minus = min:CreateFontString(nil, 'OVERLAY')
	min.minus:SetFont(STANDARD_TEXT_FONT, 15)
    min.minus:SetText'>'
	min.minus:SetPoint'CENTER'
	min.minus:SetTextColor(1, 1, 1)

	min.plus = min:CreateFontString(nil, 'OVERLAY')
	min.plus:SetFont(STANDARD_TEXT_FONT, 15)
    min.plus:SetText'<'
	min.plus:SetPoint'CENTER'
	min.plus:SetTextColor(1, 1, 1)
    min.plus:Hide()

    local title = otf.HeaderMenu.Title
    title:SetFont(STANDARD_TEXT_FONT, 13)
    title:ClearAllPoints()
    title:SetPoint('RIGHT', min, 'LEFT', -3, 0)

	min:HookScript('OnEnter', function() min.minus:SetTextColor(.7, .5, 0) min.plus:SetTextColor(.7, .5, 0) end)
	min:HookScript('OnLeave', function() min.minus:SetTextColor(1, 1, 1) min.plus:SetTextColor(1, 1, 1) end)

    hooksecurefunc('ObjectiveTracker_Collapse', function() min.plus:Show() min.minus:Hide() end)
    hooksecurefunc('ObjectiveTracker_Expand', function()   min.plus:Hide() min.minus:Show() end)

    -- quest items
    -- skin
    local function skinQuestObjectiveFrameItems(self)
        if self and not self.skinned then
            self:SetNormalTexture''
            self:SetSize(22, 22)
            self.icon:SetTexCoord(.1, .9, .1, .9)
            self:SetBackdrop(BACKDROP)
            self:SetBackdropColor(0, 0, 0)
            self.skinned = true
        end
    end

    -- reposition
    -- nb: GetParent() fucks up constantly so we're using GetPoint() instead
    local function moveQuestObjectiveItems(self)
	    local a = {self:GetPoint()}
	    self:ClearAllPoints()
		self:SetPoint('TOPRIGHT', a[2], 'TOPLEFT', -13, -7)
		self:SetFrameLevel(0)
	end

	-- implement
	local qitime = 0
	local qiinterval = 1
    hooksecurefunc('QuestObjectiveItem_OnUpdate', function(self, elapsed)
    	qitime = qitime + elapsed
    	if qitime > qiinterval then
        	skinQuestObjectiveFrameItems(self)
        	moveQuestObjectiveItems(self)
        	qitime = 0
        end
    end)

    -- QUEST_DASH
    -- acts as quest difficulty/daily indicator
    local colour_Dash = function()
        for i = 1, GetNumQuestWatches() do
            local questIndex = GetQuestIndexForWatch(i)
            if questIndex then
                local id = GetQuestWatchInfo(i)
                local block = QUEST_TRACKER_MODULE:GetBlock(id)
                local title, level, _, _, _, _, frequency = GetQuestLogTitle(questIndex)
                if block.lines then
                    for key, line in pairs(block.lines) do
                        if frequency == LE_QUEST_FREQUENCY_DAILY then
                            local red, green, blue = 1/4, 6/9, 1
                            line.Dash:SetVertexColor(red, green, blue)
                        elseif frequency == LE_QUEST_FREQUENCY_WEEKLY then
                            local red, green, blue = 0, 252/255, 177/255
                            line.Dash:SetVertexColor(red, green, blue)
                        else
                            local col = GetQuestDifficultyColor(level)
                            line.Dash:SetVertexColor(col.r, col.g, col.b)
                        end
                    end
                end
            end
        end
    end

    hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, 'AddObjective', function(self, block, objectiveKey, _, lineType)
        local line = self:GetLine(block, objectiveKey, lineType)
        if not line.styled then
            line.Text:SetFont([[Fonts/ARIALN.ttf]], 11)
            line.Text:SetWidth(width)
            line.styled = true
        end
        if line.Dash and line.Dash:IsShown() then line.Dash:SetText'— ' end
    end)

    hooksecurefunc(QUEST_TRACKER_MODULE, 'Update', colour_Dash)


    -- style text
    hooksecurefunc(QUEST_TRACKER_MODULE, 'Update', function(self)
        for i = 1, GetNumQuestWatches() do
		    local questID = GetQuestWatchInfo(i)
	        if not questID then break end

            local block = QUEST_TRACKER_MODULE:GetBlock(questID)
	        block.HeaderText:SetFont(STANDARD_TEXT_FONT, 12)
	        block.HeaderText:SetShadowOffset(.7, -.7)
            block.HeaderText:SetShadowColor(0, 0, 0, 1)
            block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
            block.HeaderText:SetJustifyH'RIGHT'
            block.HeaderText:SetWidth(width)
            block.HeaderText:SetWordWrap(true)

                -- fix overlap from double-lined headers
            local heightcheck = block.HeaderText:GetNumLines()
            if heightcheck == 2 then
                local height = block:GetHeight()
                block:SetHeight(height + 16)
            end
        end
    end)

    local function hoverquest()
        for i = 1, GetNumQuestWatches() do
		    local id = GetQuestWatchInfo(i)
	        if not id then break end
            local block = QUEST_TRACKER_MODULE:GetBlock(id)
	        block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
            colour_Dash()
        end
    end

    hooksecurefunc(QUEST_TRACKER_MODULE, 'OnBlockHeaderEnter', hoverquest)
    hooksecurefunc(QUEST_TRACKER_MODULE, 'OnBlockHeaderLeave', hoverquest)

    hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, 'Update', function(self)
        local trackedAchievements = {GetTrackedAchievements()}
        for i = 1, #trackedAchievements do
		    local achieveID = trackedAchievements[i]
		    local _, achievementName, _, completed, _, _, _, description, _, icon, _, _, wasEarnedByMe = GetAchievementInfo(achieveID)
	        local showAchievement = true

		    if wasEarnedByMe then showAchievement = false
		    elseif displayOnlyArena then
			    if GetAchievementCategory(achieveID) ~= ARENA_CATEGORY then showAchievement = false end
		    end

            if showAchievement then
			    local block = ACHIEVEMENT_TRACKER_MODULE:GetBlock(achieveID)
	            block.HeaderText:SetFont(STANDARD_TEXT_FONT, 12)
	            block.HeaderText:SetShadowOffset(.7, -.7)
                block.HeaderText:SetShadowColor(0, 0, 0, 1)
                block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
                block.HeaderText:SetJustifyH'RIGHT'
                block.HeaderText:SetWidth(width)
            end
        end
    end)

    local function hoverachieve()
    	local trackedachievements = {GetTrackedAchievements()}
    	for i = 1, #trackedachievements do
		    local id = trackedachievements[i]
	        if not id then break end
            local block = ACHIEVEMENT_TRACKER_MODULE:GetBlock(id)
	        block.HeaderText:SetTextColor(colour.r, colour.g, colour.b)
        end
    end

    hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, 'OnBlockHeaderEnter', hoverachieve)
    hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, 'OnBlockHeaderLeave', hoverachieve)


    -- hide art
    if IsAddOnLoaded'Blizzard_ObjectiveTracker' then
        hooksecurefunc('ObjectiveTracker_Update', function(reason, id)
            if otf.MODULES then
                for i = 1, #otf.MODULES do
		            otf.MODULES[i].Header.Background:SetAtlas(nil)
		            otf.MODULES[i].Header.Text:SetFont(STANDARD_TEXT_FONT, 13)
		            otf.MODULES[i].Header.Text:ClearAllPoints()
		            otf.MODULES[i].Header.Text:SetPoint('RIGHT', otf.MODULES[i].Header, -62, 0)
		            otf.MODULES[i].Header.Text:SetJustifyH'RIGHT'
	            end
	        end
	    end)
	end

    if  _G['ObjectiveTrackerBlocksFrameHeader'] then
        _G['ObjectiveTrackerBlocksFrameHeader']:SetTextColor(1, 1, 1)
    end

    -- timers
	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, 'AddTimerBar', function(self, block, line, duration, startTime)
		local tb = self.usedTimerBars[block] and self.usedTimerBars[block][line]
		if tb and tb:IsShown() and not tb.skinned then
            tb.Bar:SetHeight(5)
			tb.Bar:SetStatusBarTexture(TEXTURE)
        	tb.Bar:SetStatusBarColor(255/255, 108/255, 0/255)

            local bg = CreateFrame('Frame', nil, tb.Bar)
            bg:SetAllPoints()
            bg:SetBackdrop(BACKDROP)
            bg:SetBackdropColor(0, 0, 0)
            bg:SetFrameLevel(0)

            for _, v in pairs({tb.Bar.BorderLeft, tb.Bar.BorderRight, tb.Bar.BorderMid}) do
                v:Hide()
            end

            tb.Bar.Label:SetFont(STANDARD_TEXT_FONT, 15, 'OUTLINE')
            tb.Bar.Label:SetShadowOffset(0, -0)
            tb.Bar.Label:SetJustifyH'CENTER'
            tb.Bar.Label:ClearAllPoints()
            tb.Bar.Label:SetPoint('CENTER', pBar.Bar, 'BOTTOM', 1, -2)
            tb.Bar.Label:SetDrawLayer('OVERLAY', 7)


            tb.skinned = true
		end
	end)


    -- progress
    hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, 'AddProgressBar', function(self, block, line)
        local pBar = line.ProgressBar
        if pBar and not pBar.skinned then
            pBar.Bar:SetHeight(5)
            pBar.Bar:SetStatusBarTexture(TEXTURE)
            pBar.Bar:SetStatusBarColor(255/255, 108/255, 0/255)

            local bg = CreateFrame('Frame', nil, pBar.Bar)
            bg:SetPoint('TOPLEFT', pBar.Bar.BarBG, 1, -1)
            bg:SetPoint('BOTTOMRIGHT', pBar.Bar.BarBG)
            bg:SetBackdrop(BACKDROP)
            bg:SetBackdropColor(0, 0, 0)
            bg:SetFrameLevel(0)

            for _, v in pairs({pBar.Bar.BarFrame, pBar.Bar.Icon, pBar.Bar.IconBG}) do
                v:SetAlpha(0)
                v:Hide()
            end

            pBar.Bar.Label:SetFont(STANDARD_TEXT_FONT, 15, 'OUTLINE')
            pBar.Bar.Label:SetShadowOffset(0, -0)
            pBar.Bar.Label:SetJustifyH'CENTER'
            pBar.Bar.Label:ClearAllPoints()
            pBar.Bar.Label:SetPoint('CENTER', pBar.Bar, 'BOTTOM', 1, -2)
            pBar.Bar.Label:SetDrawLayer('OVERLAY', 7)

            pBar.skinned = true
        end
    end)


    -- rewards
    -- bonus objective
    hooksecurefunc('BonusObjectiveTracker_AnimateReward', function()
        local rewardsFrame = ObjectiveTrackerBonusRewardsFrame
        for i = 1, #rewardsFrame.Rewards do
		end
    end)

    -- scenario
    hooksecurefunc('ScenarioObjectiveTracker_AnimateReward', function()
        local rewardsFrame = ObjectiveTrackerScenarioRewardsFrame
        for i = 1, #rewardsFrame.Rewards do
        end
    end)


    -- scenarios
    local button = CreateFrame('Frame', nil, ScenarioStageBlock) button:Hide()
    local function CreateScenarioBorder(self)
        button:SetPoint('TOPLEFT', self, -1, 1)
        button:SetPoint('BOTTOMRIGHT', self, 1, -1)
        button:Show()
    end

    hooksecurefunc(SCENARIO_TRACKER_MODULE, 'AddProgressBar', function(self, block, line)
        local pBar = line.ProgressBar
        if pBar and not pBar.skinned then
            pBar.Bar:SetHeight(5)
            pBar.Bar:SetStatusBarTexture(TEXTURE)
            pBar.Bar:SetStatusBarColor(255/255, 108/255, 0/255)

            local bg = CreateFrame('Frame', nil, pBar.Bar)
            bg:SetPoint('TOPLEFT', pBar.Bar.BarBG, 1, -1)
            bg:SetPoint('BOTTOMRIGHT', pBar.Bar.BarBG)
            bg:SetBackdrop(BACKDROP)
            bg:SetBackdropColor(0, 0, 0)
            bg:SetFrameLevel(0)

            for _, v in pairs({pBar.Bar.BarFrame, pBar.Bar.Icon, pBar.Bar.IconBG}) do
                v:Hide()
            end

            pBar.Bar.Label:SetFont(STANDARD_TEXT_FONT, 15, 'OUTLINE')
            pBar.Bar.Label:SetShadowOffset(0, -0)
            pBar.Bar.Label:SetJustifyH'CENTER'
            pBar.Bar.Label:ClearAllPoints()
            pBar.Bar.Label:SetPoint('CENTER', pBar.Bar, 'BOTTOM', 1, -2)
            pBar.Bar.Label:SetDrawLayer('OVERLAY', 7)

            pBar.skinned = true
        end
    end)

    local function SkinScenarioButtons()
        local block = ScenarioStageBlock
        local _, currentStage, numStages, flags = C_Scenario.GetInfo()

        block:SetSize(width + 21, 40)

        -- pop-up artwork
        -- we have to independently resize the artwork
        -- because we're messing with the tracker width >_>
        block.NormalBG:SetWidth(width + 21)
        block.NormalBG:SetTexture''

        block.Stage:ClearAllPoints()
        block.Stage:SetPoint('LEFT', 17, 0)

        -- pop-up final artwork
        block.FinalBG:SetSize(width + 21, 50)
        block.FinalBG:SetTexture''

        -- pop-up glo
        block.GlowTexture:SetWidth(width + 20)

        -- skin
        if block and not block.skinned then
            if currentStage and currentStage <= numStages then
                CreateScenarioBorder(block)
            elseif block == ScenarioProvingGroundsBlock then
            	CreateScenarioBorder(block)
            else
                HideScenarioBorder(block)
            end
            block.skinned = true
        end
    end

    -- proving ground
    local function CreatePGBorder(self)
    	local pgbu = CreateFrame('Frame', nil, ScenarioProvingGroundsBlock)
        pgbu:SetPoint('TOPLEFT', self, -1, 1)
        pgbu:SetPoint('BOTTOMRIGHT', self, 1, -1)
    end

    local function SkinProvingGroundButtons()
        local block = ScenarioProvingGroundsBlock
        local sb = block.StatusBar
        local anim = ScenarioProvingGroundsBlockAnim

        block.MedalIcon:SetSize(32, 32)
        block.MedalIcon:ClearAllPoints()
        block.MedalIcon:SetPoint('TOPLEFT', block, 20, -10)

        block.WaveLabel:ClearAllPoints()
        block.WaveLabel:SetPoint('LEFT', block.MedalIcon, 'RIGHT', 3, 0)

        block.BG:SetSize(width + 21, 75)

        block.GoldCurlies:ClearAllPoints()
        block.GoldCurlies:SetPoint('TOPLEFT', block.BG, 6, -6)
        block.GoldCurlies:SetPoint('BOTTOMRIGHT', block.BG, -6, 6)

        anim.BGAnim:SetSize(width + 21, 75)
        anim.BorderAnim:SetSize(width + 21, 75)
        anim.BorderAnim:ClearAllPoints()
        anim.BorderAnim:SetPoint('TOPLEFT', block.BG, 8, -8)
        anim.BorderAnim:SetPoint('BOTTOMRIGHT', block.BG, -8, 8)

        sb:SetStatusBarTexture(TEXTURE)
        sb:SetStatusBarColor(0/255, 155/255, 90/255)
        sb:ClearAllPoints()
        sb:SetPoint('TOPLEFT', block.MedalIcon, 'BOTTOMLEFT', -4, -5)

        if block and not block.skinned then
            CreatePGBorder(block)
            block.skinned = true
        end
    end

    -- challenge mode
    -- note: untested
	local function CreateCMBorder(self)
    	local cmbu = CreateFrame('Frame', nil, ScenarioChallengeModeBlock)
        cmbu:SetPoint('TOPLEFT', self, -1, 1)
        cmbu:SetPoint('BOTTOMRIGHT', self, 1, -1)
    end

    local function SkinCMButtons()
        local block = ScenarioChallengeModeBlock
        local sb = block.Statusbar

        sb:SetStatusBarTexture(TEXTURE)
        sb:SetStatusBarColor(0/255, 155/255, 90/255)

        if block and not block.skinned then
            CreateCMBorder(block)
            block.skinned = true
        end
    end


        -- AUTO QUEST POP-UP

    local function alterAQButton()
        local pop = GetNumAutoQuestPopUps()
        for i = 1, pop do
            local questID, popUpType = GetAutoQuestPopUp(i)
            local questTitle = GetQuestLogTitle(GetQuestLogIndexByID(questID))

            if questTitle and questTitle ~= '' then
                local block = AUTO_QUEST_POPUP_TRACKER_MODULE:GetBlock(questID)
                if block then
                    local blockframe = block.ScrollChild

                    if not blockframe.bu then
                        local bu = CreateFrame('Frame', nil, blockframe)
                        bu:SetPoint('TOPLEFT', blockframe, 40, -4)
                        bu:SetPoint('BOTTOMRIGHT', blockframe, 0, 4)
                        bu:SetBackdrop(BACKDROP_BORDER)
                        bu:SetBackdropColor(0, 0, 0, 5)
                        bu:SetBackdropBorderColor(0, 0, 0)
                        bu:SetFrameLevel(0)
                        blockframe.bu = bu

                        blockframe.FlashFrame.IconFlash:Hide()

                        if popUpType == 'COMPLETE' then
                            blockframe.QuestIconBg:SetAlpha(0) blockframe.QuestIconBadgeBorder:SetAlpha(0)

                            blockframe.QuestionMark:ClearAllPoints()
                            blockframe.QuestionMark:SetPoint('CENTER', bu, 'LEFT', 10, 0)
                            blockframe.QuestionMark:SetParent(bu)
                            blockframe.QuestionMark:SetDrawLayer('OVERLAY', 7)
                            blockframe.IconShine:Hide()
                        elseif popUpType == 'OFFER' then
                            blockframe.QuestIconBg:SetAlpha(0) blockframe.QuestIconBadgeBorder:SetAlpha(0)

                            blockframe.Exclamation:ClearAllPoints()
                            blockframe.Exclamation:SetPoint('CENTER', bu, 'LEFT', 10, 0)
                            blockframe.Exclamation:SetParent(bu)
                            blockframe.Exclamation:SetDrawLayer('OVERLAY', 7)
                        end

                        blockframe.FlashFrame:Hide()
                        blockframe.Bg:Hide()
                        for _, v in pairs({
                            blockframe.BorderTopLeft, blockframe.BorderTopRight, blockframe.BorderBotLeft, blockframe.BorderBotRight,
                            blockframe.BorderLeft,    blockframe.BorderRight,    blockframe.BorderTop,     blockframe.BorderBottom}) do
                            v:Hide()
                        end
                    end
                end
            end
        end
    end


        -- IMPLEMENT
    local ObjFhandler = CreateFrame'Frame'
    ObjFhandler:RegisterEvent'ADDON_LOADED'
    ObjFhandler:RegisterEvent'PLAYER_ENTERING_WORLD'
    ObjFhandler:RegisterEvent'QUEST_AUTOCOMPLETE'
    ObjFhandler:RegisterEvent'QUEST_LOG_UPDATE'
    ObjFhandler:SetScript('OnEvent', function(self, event, addon)
        if addon == 'Blizzard_ObjectiveTracker' then
            SkinScenarioButtons() alterAQButton() SkinAQButton()
        end
    end)

    if IsAddOnLoaded'Blizzard_ObjectiveTracker' then
            -- scenario
        hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, 'Update', SkinScenarioButtons)
        hooksecurefunc('ScenarioBlocksFrame_OnLoad', SkinScenarioButtons)
            -- proving grounds
        hooksecurefunc('Scenario_ProvingGrounds_ShowBlock', SkinProvingGroundButtons)
            -- challenge mode
        hooksecurefunc('Scenario_ChallengeMode_ShowBlock', SkinCMButtons)
        hooksecurefunc(AUTO_QUEST_POPUP_TRACKER_MODULE, 'Update', alterAQButton)
    end

    --
