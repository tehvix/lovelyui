

	local BACKDROP 		 	 = {bgFile = [[Interface\ChatFrame\ChatFrameBackground]]}
	local TEXTURE  		 	 = [[Interface\AddOns\lovelyui\art\statusbar]]
	local _, class 		 	 = UnitClass'player'
	local color    		 	 = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
	local b1, r1, saveOnShow = {}, {}

	local combat = true		-- toggle whether bar auto-shows on combat entry
	local locked = false

	local f = CreateFrame('Frame', nil, UIParent)
	f:SetHeight(100)
	f:SetPoint'LEFT' f:SetPoint'RIGHT' f:SetPoint'BOTTOM'

	local bar = CreateFrame('Frame', 'modbar', f)
	bar:SetHeight(100) bar:SetWidth(f:GetWidth())
	bar:SetPoint('TOP', f, 'BOTTOM', 0, 80)
	bar:SetBackdrop(BACKDROP)
	bar:SetBackdropColor(0, 0, 0, .5)

	bar.px = bar:CreateTexture(nil, 'OVERLAY')
	bar.px:SetHeight(1)
	bar.px:SetPoint'TOPLEFT' bar.px:SetPoint'TOPRIGHT'
	bar.px:SetTexture(0, 0, 0)

	local ol = bar:CreateTexture(nil, 'BACKGROUND')
	ol:SetTexture[[Interface/AddOns/lovelyui/art/bigblackoverlay.tga]]
	ol:SetPoint('TOPLEFT', UIParent)
	ol:SetPoint('BOTTOMRIGHT', bar, 'TOPRIGHT')
	ol:SetAlpha(.3)

	local bottom = bar:CreateTexture(nil, 'ARTWORK')
	bottom:SetTexture(TEXTURE)
	bottom:SetHeight(3)
	bottom:SetPoint('BOTTOMLEFT',  bar, 'TOPLEFT', 0, 12)
	bottom:SetPoint('BOTTOMRIGHT', bar, 'TOPRIGHT', 0, 12)
	bottom:SetVertexColor(0, 0, 0)

	local desc = CreateFrame('Frame', nil, Minimap)
	desc:SetSize(80, 14)
	desc:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', 0, -24)

	desc.t = desc:CreateFontString(nil, 'OVERLAY')
	desc.t:SetPoint'TOPLEFT'
	desc.t:SetWidth(80)
	desc.t:SetJustifyH'LEFT'
	desc.t:SetFont([[Fonts\ARIALN.ttf]], 9)
	desc.t:SetShadowOffset(1, -1.25)
	desc.t:SetShadowColor(0, 0, 0, 1)
	desc.t:SetTextColor(1, 1, 1)
	desc.t:SetText''

	for i = 1, 11 do
		local bu = CreateFrame('Button', 'bar_bu'..i, Minimap)
		bu:SetSize(21, 5)
		bu:SetBackdrop({bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
		insets = {left = -3, right = -3, top = -3, bottom = -3}})
		bu:SetBackdropColor(0, 0, 0, .9)

		bu.i = bu:CreateTexture(nil, 'ARTWORK')
		bu.i:SetAllPoints()


		if i > 1 then
			table.insert(b1, bu)
			bu:SetParent(bar)
			bu.i:SetTexture[[Interface\ChatFrame\ChatFrameBackground]]
		end

		if i == 1 then
			bu:SetSize(20, 23)
			bu:SetScript('OnClick', function() ToggleCharacter'PaperDollFrame' end)
			bu:SetScript('OnEnter', function() desc.t:SetText'Character' end)
			bu:SetScript('OnLeave', function() desc.t:SetText'' end)
			SetPortraitTexture(bu.i, 'player')
			bu.i:SetTexCoord(.2, .65, .15, .675)
			bu:RegisterUnitEvent('UNIT_PORTRAIT_UPDATE', 'player')
			bu:SetScript('OnEvent', function() SetPortraitTexture(bu.i, 'player') end)
		elseif i == 2 then	-- spellbook
			bu:SetScript('OnClick', function()
				ToggleSpellBook(BOOKTYPE_SPELL)
			end)
			bu:SetScript('OnEnter', function() desc.t:SetText'Spellbook' end)
			bu:SetScript('OnLeave', function() desc.t:SetText'' end)
			bu.i:SetVertexColor(120/255, 88/255, 237/255)
		elseif i == 3 then	-- talentframe
			bu:SetScript('OnClick', ToggleTalentFrame)
			bu:SetScript('OnEnter', function() desc.t:SetText'Talents' end)
			bu:SetScript('OnLeave', function() desc.t:SetText'' end)
			bu.i:SetVertexColor(1, 1, .9)
		elseif i == 4 then	-- achievement
			bu:SetScript('OnClick', ToggleAchievementFrame)
			bu:SetScript('OnEnter', function() desc.t:SetText'Achievements' end)
			bu:SetScript('OnLeave', function() desc.t:SetText'' end)
			bu.i:SetVertexColor(251/255, 93/255, 37/255)
		elseif i == 5 then	-- questlog
			bu:SetScript('OnClick', ToggleQuestLog)
			bu:SetScript('OnEnter', function() desc.t:SetText'Quest Log' end)
			bu:SetScript('OnLeave', function() desc.t:SetText'' end)
			bu.i:SetVertexColor(253/255, 38/255, 205)
		elseif i == 6 then 	-- social
			bu:SetScript('OnClick', ToggleFriends)
			bu:SetScript('OnEnter', function() desc.t:SetText'Social' end)
			bu:SetScript('OnLeave', function() desc.t:SetText'' end)
			bu.i:SetVertexColor(133/255, 117/255, 78/255)
		elseif i == 7 then 	-- lfd
			bu:SetScript('OnClick', PVEFrame_ToggleFrame)
			bu:SetScript('OnEnter', function() desc.t:SetText'LFD' end)
			bu:SetScript('OnLeave', function() desc.t:SetText'' end)
			bu.i:SetVertexColor(.7, .6, .7)
		elseif i == 8 then	-- collection
			bu:SetScript('OnClick', ToggleCollectionsJournal)
			bu:SetScript('OnEnter', function() desc.t:SetText'Mounts, Pets, Toys & Heirlooms' end)
			bu:SetScript('OnLeave', function() desc.t:SetText'' end)
			bu.i:SetVertexColor(30/255, 39/255, 205/255)
		elseif i == 9 then	-- encounter journal
			bu:SetScript('OnClick', ToggleEncounterJournal)
			bu:SetScript('OnEnter', function() desc.t:SetText'Encounter Journal' end)
			bu:SetScript('OnLeave', function() desc.t:SetText'' end)
			bu.i:SetVertexColor(97/255, 208/255, 30/255)
		elseif i == 10 then	-- store
			bu:SetScript('OnClick', ToggleStoreUI)
			bu:SetScript('OnEnter', function() desc.t:SetText'Shop' end)
			bu:SetScript('OnLeave', function() desc.t:SetText'' end)
			bu.i:SetVertexColor(246/255, 239/255, 37/255)
		elseif i == 11 then	-- help
			bu:SetScript('OnClick', ToggleHelpFrame)
			bu:SetScript('OnEnter', function() desc.t:SetText'Help!' end)
			bu:SetScript('OnLeave', function() desc.t:SetText'' end)
			bu.i:SetVertexColor(255/255, 38/255, 38/255)
		end

		if i == 1 then
			bu:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', 5, 20)
		else
			if i == 2 then
				bu:SetPoint('TOPRIGHT', bar, 'TOP', -75, 0)
			else
				bu:SetPoint('TOP', _G['bar_bu'..(i - 1)], 'BOTTOM', 0, -3)
			end
		end
	end

		-- bag
	MainMenuBarBackpackButton:ClearAllPoints()
	MainMenuBarBackpackButton:SetPoint('RIGHT', f, -40, -10)
	table.insert(b1, MainMenuBarBackpackButton)

	local backbg = CreateFrame('Frame', nil, MainMenuBarBackpackButton)
	backbg:SetPoint('TOPLEFT', -3, 3)
	backbg:SetPoint('BOTTOMRIGHT', 3, -3)
	backbg:SetBackdrop(BACKDROP)
	backbg:SetBackdropColor(0, 0, 0)

	MainMenuBarBackpackButtonIconTexture:SetParent(backbg)
	MainMenuBarBackpackButtonCount:SetParent(backbg)

		--action1
	local bar1 = CreateFrame('Frame', 'mod_bar1', UIParent, 'SecureHandlerStateTemplate')
	bar1:SetSize(20*4 + 38, 20*3 + 14)

		-- multileft
	local bar2 = CreateFrame('Frame', 'mod_bar2', UIParent, 'SecureHandlerStateTemplate')
	bar2:SetSize(20*12 + 38, 20 + 14)

		-- multiright
	local bar3 = CreateFrame('Frame', 'mod_bar3', UIParent, 'SecureHandlerStateTemplate')
	bar3:SetSize(20*12 + 38, 20 + 14)

		-- right
	local bar4 = CreateFrame('Frame', 'mod_bar4', UIParent, 'SecureHandlerStateTemplate')
	bar4:SetSize(20*12 + 38, 20 + 14)

		-- left
	local bar5 = CreateFrame('Frame', 'mod_bar5', UIParent, 'SecureHandlerStateTemplate')
	bar5:SetSize(20*12 + 38, 20 + 14)

		-- stance
	local bar6 = CreateFrame('Frame', 'mod_bar6', UIParent, 'SecureHandlerStateTemplate')
	bar6:SetSize(18*5 + 38, 18*2 + 14)

	bar1:SetPoint('BOTTOM', f, 6, 10)
	bar2:SetPoint('TOPLEFT', f, 120, -27)
	bar3:SetPoint('TOP', bar2, 'BOTTOM')
	bar5:SetPoint('TOPRIGHT', f, -150, -27)
	bar4:SetPoint('TOP', bar5, 'BOTTOM')
	-- bar6:SetPoint('BOTTOMRIGHT', bar4, 'BOTTOMLEFT', -10, 0)

	MainMenuBarArtFrame:SetParent(bar1)
    MainMenuBarArtFrame:EnableMouse(false)

    for i = 1, 12 do
		local bu = _G['ActionButton'..i]
		bu:SetSize(20, 20)
		bu:ClearAllPoints()
		tinsert(b1, bu)
		if i == 1 then
        	bu:SetPoint('TOPLEFT', bar1, 4, -4)
		else
			if i == 5 then
				bu:SetPoint('TOP', _G['ActionButton1'], 'BOTTOM', 0, -6)
			elseif i == 9 then
				bu:SetPoint('TOP', _G['ActionButton5'], 'BOTTOM', 0, -6)
			else
				bu:SetPoint('LEFT', _G['ActionButton'..i - 1], 'RIGHT', 6, 0)
			end
		end
    end

		-- pg no.
	for _, v in pairs({MainMenuBarPageNumber, ActionBarDownButton, ActionBarUpButton,}) do
		v:ClearAllPoints()
		if v ~= MainMenuBarPageNumber then table.insert(b1, v) end
	end

	MainMenuBarPageNumber:SetPoint('RIGHT', bar1, 'LEFT', -8, -4)
	MainMenuBarPageNumber:SetFont([[Fonts\ARIALN.ttf]], 12)
	MainMenuBarPageNumber:SetShadowOffset(1, -1.25)
	MainMenuBarPageNumber:SetShadowColor(0, 0, 0, 1)
	MainMenuBarPageNumber:SetTextColor(1, 1, 1)

	ActionBarUpButton.t = ActionBarUpButton:CreateFontString(nil, 'OVERLAY')
	ActionBarUpButton.t:SetPoint'LEFT'
	ActionBarUpButton.t:SetJustifyH'LEFT'
	ActionBarUpButton.t:SetFont([[Fonts\ARIALN.ttf]], 11)
	ActionBarUpButton.t:SetShadowOffset(1, -1.25)
	ActionBarUpButton.t:SetShadowColor(0, 0, 0, 1)
	ActionBarUpButton.t:SetTextColor(1, 1, 1)
	ActionBarUpButton.t:SetText'Up'

	ActionBarUpButton:SetSize(20, 20)
	ActionBarUpButton:SetPoint('TOPRIGHT', bar1, 22, -8)
	ActionBarUpButton:SetNormalTexture'' ActionBarUpButton:SetPushedTexture''
	ActionBarUpButton:SetDisabledTexture'' ActionBarUpButton:SetHighlightTexture''

	ActionBarDownButton.t = ActionBarDownButton:CreateFontString(nil, 'OVERLAY')
	ActionBarDownButton.t:SetPoint'LEFT'
	ActionBarDownButton.t:SetJustifyH'LEFT'
	ActionBarDownButton.t:SetFont([[Fonts\ARIALN.ttf]], 11)
	ActionBarDownButton.t:SetShadowOffset(1, -1.25)
	ActionBarDownButton.t:SetShadowColor(0, 0, 0, 1)
	ActionBarDownButton.t:SetTextColor(1, 1, 1)
	ActionBarDownButton.t:SetText'Dn'

	ActionBarDownButton:SetSize(20, 20)
	ActionBarDownButton:SetPoint('BOTTOMRIGHT', bar1, 22, 13)
	ActionBarDownButton:SetNormalTexture'' ActionBarDownButton:SetPushedTexture''
	ActionBarDownButton:SetDisabledTexture'' ActionBarDownButton:SetHighlightTexture''

	for i = 1, 12 do
		local bu = _G['MultiBarBottomLeftButton'..i]
		bu:SetSize(20, 20)
		bu:ClearAllPoints()
		tinsert(b1, bu)
		if i == 1 then
			bu:SetPoint('TOPLEFT', bar2, 4, -4)
		else
			bu:SetPoint('LEFT', _G['MultiBarBottomLeftButton'..i - 1], 'RIGHT', 6, 0)
		end
	end

	for i = 1, 12 do
		local bu = _G['MultiBarBottomRightButton'..i]
		bu:SetSize(20, 20)
		bu:ClearAllPoints()
		tinsert(b1, bu)
		if i == 1 then
			bu:SetPoint('TOPLEFT', bar3, 4, -4)
		else
			bu:SetPoint('LEFT', _G['MultiBarBottomRightButton'..i - 1], 'RIGHT', 6, 0)
		end
	end

	for i = 1, 12 do
		local bu = _G['MultiBarLeftButton'..i]
		bu:SetSize(20, 20)
		bu:ClearAllPoints()
		tinsert(b1, bu)
		if i == 1 then
			bu:SetPoint('TOPLEFT', bar4, 4, -4)
		else
			bu:SetPoint('LEFT', _G['MultiBarLeftButton'..i - 1], 'RIGHT', 6, 0)
			end
	end

	for i = 1, 12 do
		local bu = _G['MultiBarRightButton'..i]
		bu:SetSize(20, 20)
		bu:ClearAllPoints()
		tinsert(b1, bu)
		if i == 1 then
			bu:SetPoint('TOPLEFT', bar5, 4, -4)
		else
			bu:SetPoint('LEFT', _G['MultiBarRightButton'..i - 1], 'RIGHT', 6, 0)
		end
	end

	for i = 1, 10 do
		local bu = _G['StanceButton'..i]
		bu:SetSize(18, 18)
		bu:ClearAllPoints()
		tinsert(b1, bu)
		if i == 1 then
			bu:SetPoint('TOPLEFT', bar6, 4, -4)
		elseif i == 7 then
			bu:SetPoint('TOPLEFT', _G['StanceButton1'], 'BOTTOMLEFT', 0, -6)
		else
			bu:SetPoint('LEFT', _G['StanceButton'..(i - 1)], 'RIGHT', 6, 0)
		end
	end


		-- pet
	local pet = CreateFrame('Button', nil, bar)
	pet:SetSize(100, 15)
	pet:SetPoint('CENTER', bar, 180, 18)
	pet:RegisterEvent'PLAYER_ENTERING_WORLD'
	pet:RegisterUnitEvent('UNIT_PET', 'player')

	pet.t = pet:CreateFontString(nil, 'OVERLAY')
	pet.t:SetPoint'LEFT'
	pet.t:SetFont(STANDARD_TEXT_FONT, 13)
	pet.t:SetShadowOffset(1, -1.25)
	pet.t:SetShadowColor(0, 0, 0, 1)
	pet.t:SetTextColor(color.r, color.g, color.b)
	pet.t:SetText'> Pet Bar'

		-- sliding animation
	local active = false
	local offset = 95
	local slideGroup1 = pet:CreateAnimationGroup'petslide1'
	local slideGroup2 = pet:CreateAnimationGroup'petslide2'

	local slide1 = slideGroup1:CreateAnimation'Translation'
	slide1:SetDuration(.22)
	slide1:SetOffset(offset, 0)
	slide1:SetSmoothing'OUT'
	slide1:SetScript('OnPlay', function()
		pet:ClearAllPoints()
		pet:SetPoint('CENTER', bar, 180, 18)
	end)
	slide1:SetScript('OnFinished', function()
		active = false
		pet:ClearAllPoints()
		pet:SetPoint('CENTER', bar, 275, 18)
		slideGroup1:Stop()
	end)

	local slide2 = slideGroup2:CreateAnimation'Translation'
	slide2:SetDuration(.22)
	slide2:SetOffset(-offset, 0)
	slide2:SetSmoothing'OUT'
	slide2:SetScript('OnPlay', function()
		pet:ClearAllPoints()
		pet:SetPoint('CENTER', bar, 275, 18)
	end)
	slide2:SetScript('OnFinished', function()
		active = false
		pet:ClearAllPoints()
		pet:SetPoint('CENTER', bar, 180, 18)
		slideGroup2:Stop()
	end)

	local fade1 = slideGroup1:CreateAnimation'Alpha'
	fade1:SetFromAlpha(1)
	fade1:SetToAlpha(0)
	fade1:SetDuration(.5)
	fade1:SetSmoothing'OUT'

	local fade2 = slideGroup2:CreateAnimation'Alpha'
	fade2:SetFromAlpha(0)
	fade2:SetToAlpha(1)
	fade2:SetDuration(.5)
	fade2:SetSmoothing'OUT'

	pet:SetScript('OnClick', function()
		local t = pet.t:GetText()
		if t == '-' then
			wipe(r1)
			if not active then
				active = true
				slideGroup2:Play()
			end
			for i = 1, 10 do
				local bu = _G['PetActionButton'..i]
				bu.cooldown:SetDrawBling(false)
				bu:SetAlpha(0)
				for j = 1, #b1 do
					local v = b1[j]
					if v then
						local n = v:GetName()
						if n ~= nil and strmatch(n, 'PetActionButton(.+)') then tinsert(r1, j) end
					end
				end
			end
			for _, v in pairs(r1) do tremove(b1, v) end
			pet.t:SetText'> Pet Bar'
		else
			if not active then
				active = true
				slideGroup1:Play()
			end
			for i = 1, 10 do
				local bu = _G['PetActionButton'..i]
				bu.cooldown:SetDrawBling(true)
				bu:SetAlpha(1)
				tinsert(b1, bu)
			end
			pet.t:SetText'-'
		end
	end)

	pet:SetScript('OnEvent', function(self)
		if UnitExists'pet' then
			 self:Show()
			 table.insert(b1, pet)
		 else
			 self:Hide()
		  end
	end)

	for i = 0, 1 do _G['SlidingActionBarTexture'..i]:SetAlpha(0) end

	local pet1 = CreateFrame('Frame', 'mod_pet1', UIParent, 'SecureHandlerStateTemplate')
	pet1:SetSize(16*5 + 21, 7*2 + 10)
	pet1:SetPoint('BOTTOM', UIParent, 185, 22)
	table.insert(b1, pet1)

	PetActionBarFrame:SetParent(pet1)
    PetActionBarFrame:EnableMouse(false)

	for i = 1, 10 do
		local bu = _G['PetActionButton'..i]
		bu:SetSize(16, 7)
		bu:ClearAllPoints()
		tinsert(b1, bu)
		if i == 1 then
        	bu:SetPoint('TOPLEFT', pet1, 2, -2)
		else
			if i == (10/2+1) then
				bu:SetPoint('TOP', _G['PetActionButton1'], 'BOTTOM', 0, -6)
			else
				bu:SetPoint('LEFT', _G['PetActionButton'..i- 1], 'RIGHT', 4, 0)
			end
		end
	end

	RegisterStateDriver(pet1, 'visibility', '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show')
	for i = 1, 6 do
		RegisterStateDriver(_G['mod_bar'..i], 'visibility', '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show')
	end

	local buttons = function(show)
		MainMenuBarBackpackButton:SetAlpha(show and 1 or 0)
		for i = 1, 12 do
			for _, v in pairs ({
				_G['ActionButton'..i],
				_G['MultiBarBottomLeftButton'..i],
				_G['MultiBarBottomRightButton'..i],
				_G['MultiBarLeftButton'..i],
				_G['MultiBarRightButton'..i],
				_G['StanceButton'..i],
			}) do
				if  v then
					v.cooldown:SetDrawBling(show)
					v:SetAlpha(show and 1 or 0)
				end
			end
		end
		for i = 1, 10 do
			local bu = _G['PetActionButton'..i]
			if bu then
				if pet.t:GetText() == '>' then
					bu.cooldown:SetDrawBling(show)
					bu:SetAlpha(show and 1 or 0)
				else
					bu.cooldown:SetDrawBling(false)
					bu:SetAlpha(0)
				end
			end
		end
	end

	local frames = function(show)
		for _, v in pairs(b1) do
			local n = v:GetName()
			if n == nil or not strmatch(n, 'ActionButton(.+)') then
				if show then v:SetAlpha(1) else v:SetAlpha(0) end
			end
		end
		if show then
			MainMenuBarPageNumber:Show()
		else
			MainMenuBarPageNumber:Hide()
		end
	end

	f:SetScript('OnUpdate', function()	-- fire on login
		local x = {bar:GetPoint()}
		if x[5] > 4 then
			bar:ClearAllPoints()
			bar:SetPoint(x[1], x[2], x[3], x[4], x[5] - 6)
			if x[5] < 60 then
				buttons(false)
				frames(false)
			end
		else
			f:SetScript('OnUpdate', nil)
		end
	end)

	for _, v in pairs(b1) do
		v:HookScript('OnEnter', function()
			f:SetScript('OnUpdate', function()
				local x = {bar:GetPoint()}
				if x[5] < 80 then
					bar:ClearAllPoints()
					bar:SetPoint(x[1], x[2], x[3], x[4], x[5] + 6)
					if x[5] > 60 then
						buttons(true)
						frames(true)
					else
						buttons(false)
						frames(false)
					end
				else
					f:SetScript('OnUpdate', nil)
				end
			end)
		 end)

		v:HookScript('OnLeave', function()
			f:SetScript('OnUpdate', function()
				local x = {bar:GetPoint()}
				if x[5] > 4 then
					bar:ClearAllPoints()
					bar:SetPoint(x[1], x[2], x[3], x[4], x[5] - 6)
					if x[5] < 60 then
						buttons(false)
						frames(false)
					else
						buttons(true)
						frames(true)
					end
				else
					f:SetScript('OnUpdate', nil)
				end
			end)
		end)
	end

	f:SetScript('OnEnter', function()
		f:SetScript('OnUpdate', function()
			local x = {bar:GetPoint()}
			if x[5] < 80 then
				bar:ClearAllPoints()
				bar:SetPoint(x[1], x[2], x[3], x[4], x[5] + 6)
				if x[5] > 60 then
					buttons(true)
					frames(true)
				else
					buttons(false)
					frames(false)
				end
			else
				f:SetScript('OnUpdate', nil)
			end
		end)
	 end)

	f:SetScript('OnLeave', function()
		f:SetScript('OnUpdate', function()
			local x = {bar:GetPoint()}
			if x[5] > 4 then
				bar:ClearAllPoints()
				bar:SetPoint(x[1], x[2], x[3], x[4], x[5] - 6)
				if x[5] < 60 then
					buttons(false)
					frames(false)
				else
					buttons(true)
					frames(true)
				end
			else
				f:SetScript('OnUpdate', nil)
			end
		end)
	end)

	SpellBookFrame:HookScript('OnShow', function()
		f:SetScript('OnUpdate', function()
			local x = {bar:GetPoint()}
			if x[5] < 80 then
				bar:ClearAllPoints()
				bar:SetPoint(x[1], x[2], x[3], x[4], x[5] + 6)
				if x[5] > 60 then
					buttons(true)
					frames(true)
				else
					buttons(false)
					frames(false)
				end
			else
				f:SetScript('OnUpdate', nil)
			end
		end)
	end)

	SpellBookFrame:HookScript('OnHide', function()
		f:SetScript('OnUpdate', function()
			local x = {bar:GetPoint()}
			if x[5] > 4 then
				bar:ClearAllPoints()
				bar:SetPoint(x[1], x[2], x[3], x[4], x[5] - 6)
				if x[5] < 60 then
					buttons(false) frames(false)
				else
					buttons(true)  frames(true)
				end
			else
				f:SetScript('OnUpdate', nil)
			end
		end)
	end)

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_REGEN_DISABLED'
	e:RegisterEvent'PLAYER_REGEN_ENABLED'
	e:SetScript('OnEvent', function(self, event)
		if combat then
			if event == 'PLAYER_REGEN_DISABLED' then
				f:SetScript('OnUpdate', function()
					local x = {bar:GetPoint()}
					if x[5] < 80 then
						bar:ClearAllPoints()
						bar:SetPoint(x[1], x[2], x[3], x[4], x[5] + 6)
						if x[5] > 60 then
							buttons(true)
							frames(true)
						else
							buttons(false)
							frames(false)
						end
					else
						f:SetScript('OnUpdate', nil)
					end
				end)
			else
				f:SetScript('OnUpdate', function()
					local x = {bar:GetPoint()}
					if x[5] > 4 then
						bar:ClearAllPoints()
						bar:SetPoint(x[1], x[2], x[3], x[4], x[5] - 6)
						if x[5] < 60 then
							buttons(false) frames(false)
						else
							buttons(true)  frames(true)
						end
					else
						f:SetScript('OnUpdate', nil)
					end
				end)
			end
		end
	end)
