

	local BACKDROP = {
		bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
		insets = {left = -3, right = -3, top = -3, bottom = -3}
	}
	local TEXTURE  = [[Interface\AddOns\lovelyui\art\statusbar]]
	local _, class = UnitClass'player'
	local color    = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

	local kb 	   = false

	local function IsSpecificButton(self, name)
		local sbut = self:GetName():match(name)
		if sbut then
			return true
		else
			return false
		end
	end

    MainMenuBarBackpackButton:SetCheckedTexture''
    MainMenuBarBackpackButton:SetNormalTexture''
	MainMenuBarBackpackButtonIconTexture:SetTexCoord(.1, .9, .1, .9)
	MainMenuBarBackpackButton:SetBackdrop(BACKDROP)
	MainMenuBarBackpackButton:SetBackdropColor(0, 0, 0, 1)
    MainMenuBarBackpackButtonCount:SetDrawLayer('OVERLAY', 7)
    MainMenuBarBackpackButtonCount:ClearAllPoints()
    MainMenuBarBackpackButtonCount:SetPoint('CENTER', MainMenuBarBackpackButton, 'BOTTOM')
    MainMenuBarBackpackButtonCount:SetFont(STANDARD_TEXT_FONT, 14, 'OUTLINE')
    MainMenuBarBackpackButtonCount:SetJustifyH'CENTER'

	local function UpdateSlotsFree()
        local totalFree, freeSlots, bagFamily = 0
        for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
            freeSlots, bagFamily = GetContainerNumFreeSlots(i)
            if bagFamily == 0 then
                totalFree = totalFree + freeSlots
            end
        end
        MainMenuBarBackpackButtonCount:SetText(string.format('%s', totalFree))
    end

	hooksecurefunc('MainMenuBarBackpackButton_UpdateFreeSlots', UpdateSlotsFree)

		-- PET/STANCE/POSSESS
	local function skinX()
		for _, name in pairs({'PetActionButton', 'PossessButton', 'StanceButton'}) do
			for i = 1, 12 do
				local bu = _G[name..i]
				if bu then
						-- button
					bu:SetCheckedTexture''
					bu:SetNormalTexture''

					bu:SetBackdrop(BACKDROP)
					bu:SetBackdropColor(0, 0, 0, 1)

						-- cd
					if not InCombatLockdown() then
						local cd = _G[name..i..'Cooldown']
						cd:ClearAllPoints()
						cd:SetPoint('TOPLEFT', bu, 2, -2)
						cd:SetPoint('BOTTOMRIGHT', bu, -2, 2)
					end

						-- icon
					local ic = _G[name..i..'Icon']
					ic:SetAllPoints()
					ic:SetTexCoord(.1, .9, .1, .9)
					ic:SetDrawLayer'OVERLAY'

						-- hotkey
					local hotkey = _G[name..i..'HotKey']
					if not showkeybinds then
						hotkey:Hide()
					end
				end

					-- blizz border (yuck)
				local border = _G[name..i..'Border']
				if border then border:SetAlpha(0) end

					-- pet/stance etc. specific bg
				local buttonBg = _G[name..i..'FloatingBG']
				if buttonBg then buttonBg:Hide() end

				if name == 'PetActionButton' then
					local shine = _G[name..i..'Shine']
					local ac = _G[name..i..'AutoCastable']
					local ic = _G[name..i..'Icon']

					if ic then ic:SetTexCoord(.1, .9, .35, .65) end

						-- pet shine
					if  shine then
						shine:ClearAllPoints()
						shine:SetPoint('TOPLEFT', bu, -3, 3)
						shine:SetPoint('BOTTOMRIGHT', bu, 3, -3)
						shine:SetFrameStrata'BACKGROUND'
					end

						-- auto-cast indicator
					if ac then
						ac:SetSize(40, 30)
						ac:SetDrawLayer('OVERLAY', 7)
					end
				end
			end
		end
	end

		-- implement pet etc. here
	hooksecurefunc('PetActionBar_Update',   skinX)
	hooksecurefunc('StanceBar_UpdateState', skinX)

	local function skinY(self)
            -- multi-cast
        if IsSpecificButton(self, 'MultiCast') then
            for _, icon in pairs({
                self:GetName(),
                'MultiCastRecallSpellButton',
                'MultiCastSummonSpellButton',
            }) do
                _G[icon]:SetNormalTexture''
                _G[self:GetName()..'Icon']:SetTexCoord(.1, .9, .1, .9)
            end
        else
            local button = _G[self:GetName()]

            button:SetCheckedTexture''
            button:SetPushedTexture''
			button:SetNormalTexture''

                -- hotkey
            local hotkey = _G[self:GetName()..'HotKey']
			local hkfont = CreateFont'HotkeyFontForModernists'
            hotkey:SetFont(STANDARD_TEXT_FONT, 11, 'OUTLINE')
            hotkey:ClearAllPoints()
            hotkey:SetPoint('TOPRIGHT', self, -2, 14.5)
            hkfont:SetFont(STANDARD_TEXT_FONT, 11, 'OUTLINE')
            NumberFontNormalSmallGray:SetFontObject(hkfont)
            NumberFontNormalSmallGray:SetTextColor(255/255, 209/255, 0)
            if not kb then hotkey:Hide() end

                -- border
            button:SetBackdrop(BACKDROP)
			button:SetBackdropColor(0, 0, 0, 1)

                -- icon
            local ic = _G[self:GetName()..'Icon']
            ic:SetTexCoord(.1, .9, .1, .9)
			ic:SetDrawLayer'OVERLAY'

                -- blizz border
            local border = _G[self:GetName()..'Border']
            if border then border:SetAlpha(0) end

                -- count
            local count = _G[self:GetName()..'Count']
            if count then
                count:ClearAllPoints()
                count:SetPoint('CENTER', button, 'BOTTOM', 0, 2)
                count:SetFont(STANDARD_TEXT_FONT, 14, 'OUTLINE')
                count:SetVertexColor(1, 1, 1, 1)
                count:SetDrawLayer('OVERLAY', 7)
            end

                -- macro
            local macroname = _G[self:GetName()..'Name']
            if macroname then
                macroname:SetWidth(button:GetWidth() + 15)
                macroname:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
                macroname:SetVertexColor(1, 1, 1)
            end

                -- blizz bg
            local buttonBg = _G[self:GetName()..'FloatingBG']
            if buttonBg then
                buttonBg:SetAlpha(0)
            end

                -- spell flyout stuff
            local fly = _G[self:GetName()..'FlyoutBorder']
            if fly then fly:SetTexture'' end

            local flys = _G[self:GetName()..'FlyoutBorderShadow']
            if flys then flys:SetTexture'' end
        end
    end

	hooksecurefunc('ActionButton_Update', skinY)
