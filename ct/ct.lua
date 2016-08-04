

            -- FLOATING COMBAT TEXT
            -- restyles CT strings minimally
            -- & nudges heals & damage to seperate sides

        -- nb: working at half (read: rando) capacity. must fix

    LoadAddOn'Blizzard_CombatText'

    for i = 1,20 do -- RESIZE TEXT
        local text = _G['CombatText'..i]
        text:SetFont(STANDARD_TEXT_FONT, 15)
        text:SetShadowOffset(1, -1.25)
    	text:SetShadowColor(0, 0, 0, 1)
        text:SetAlpha(.8)
        text.SetTextHeight = function(self)
            self:SetFont(STANDARD_TEXT_FONT, 15)
        end
    end

    local modCT_OnEvent = function(self, event, ...)
        if not self:IsVisible() then CombatText_ClearAnimationList() return end
        local arg1, data, arg3, arg4 = ...
        local messageType, message, displayType  -- Set up the message type & message data

            -- FETCH MESSAGE TYPE
        if event == 'UNIT_HEALTH' then
            if arg1 == self.unit then
                if UnitHealth(self.unit)/UnitHealthMax(self.unit) <= COMBAT_TEXT_LOW_HEALTH_THRESHOLD then
                    if not CombatText.lowHealth then messageType = 'HEALTH_LOW' end
                end
            end
            if not messageType then return end
        elseif event == 'UNIT_POWER' then
            if arg1 == self.unit then
                local ptype, ptoken = UnitPowerType(self.unit)
                if token == 'MANA' and (UnitPower(self.unit)/UnitPowerMax(self.unit)) <= COMBAT_TEXT_LOW_MANA_THRESHOLD then
                    if not CombatText.lowMana then messageType = 'MANA_LOW' end
                end
            end
            if not messageType then return end
        elseif event == 'PLAYER_REGEN_DISABLED' then messageType = 'ENTERING_COMBAT'
        elseif event == 'PLAYER_REGEN_ENABLED' then  messageType = 'LEAVING_COMBAT'
        elseif event == 'UNIT_COMBO_POINTS' then
            local unit = ...
            if unit == 'player' then
                local cp = GetComboPoints('player', 'target')
                if cp > 0 then
                    messageType = 'COMBO_POINTS'
                    data = comboPoints;
                    -- Show message as a crit if max combo points
                    if comboPoints == MAX_COMBO_POINTS then displayType = 'crit' end
                else return end
            else return end
        elseif event == 'COMBAT_TEXT_UPDATE' then    messageType = arg1
        elseif event == 'RUNE_POWER_UPDATE' then     messageType = 'RUNE'
        else
            messageType = event
        end

        -- Process the messageType and format the message
        -- Check to see if there's a COMBAT_TEXT_TYPE_INFO associated with this combat message
        local info = COMBAT_TEXT_TYPE_INFO[messageType]
        if not info then info = { r = 1, g =1, b = 1 } end

        -- See if we should display the message or not
        if not info.show then
            -- when resists aren't being shown, partial resists should display as damage
            if info.var == 'COMBAT_TEXT_SHOW_RESISTANCES' and arg3 then
                if strsub(messageType, 1, 5) == 'SPELL' then
                    messageType = arg4 and 'SPELL_DAMAGE_CRIT' or 'SPELL_DAMAGE'
                else
                    messageType = arg4 and 'DAMAGE_CRIT' or 'DAMAGE'
                end
            else return end
        end

        local isStaggered = nil -- overwrite xOffset stagger

            -- ?
        if messageType == '' then
            -- + COMBAT
        elseif messageType == 'ENTERING_COMBAT' then
            message = '> Combat'
            -- - COMBAT
        elseif messageType == 'LEAVING_COMBAT' then
            message = '- Combat'
            -- INCOMING CRIT
        elseif messageType == 'DAMAGE_CRIT' or messageType == 'SPELL_DAMAGE_CRIT' then
            displayType = 'minus'
            message = '— '..BreakUpLargeNumbers(data)..'!'
            -- INCOMING DMG
        elseif messageType == 'DAMAGE' or messageType == 'SPELL_DAMAGE'
        or messageType == 'DAMAGE_SHIELD' then
            displayType = 'minus'
            if data == 0 then return end
            message = '- '..BreakUpLargeNumbers(data)
            -- INCOMING SPELL, BUFF OR DEBUFF
        elseif messageType == 'SPELL_CAST' or messageType == 'SPELL_AURA_START'
        or messageType == "SPELL_AURA_START_HARMFUL" then
            displayType = 'minus'
            info.r = .4 info.g = .1 info.b = .8
            message = '—'..data
            -- FINISHED SPELL, BUFF OR DEBUFF
        elseif messageType == 'SPELL_AURA_END' or messageType == 'SPELL_AURA_END_HARMFUL' then
            displayType = 'minus'
            message = format(AURA_END, data)
            -- HEALS OR HOTS
        elseif messageType == 'HEAL' or messageType == 'PERIODIC_HEAL' then
            displayType = 'plus'
            if COMBAT_TEXT_SHOW_FRIENDLY_NAMES == '1' and messageType == 'HEAL'
            and UnitName(self.unit) ~= data then
                message = '> '..BreakUpLargeNumbers(arg3)..' : '..data..''
            else
                message = "> "..BreakUpLargeNumbers(arg3)
            end
            -- HEAL OR HOT + SHIELD
        elseif messageType == 'HEAL_ABSORB' or messageType == 'PERIODIC_HEAL_ABSORB' then
            displayType = 'plus'
            if COMBAT_TEXT_SHOW_FRIENDLY_NAMES == '1' and messageType == 'HEAL_ABSORB'
            and UnitName(self.unit) ~= data then
                message = '> '..BreakUpLargeNumbers(arg3)..' : '..data..' : '..format(ABSORB_TRAILER, arg4)
            else
                message = '> '..BreakUpLargeNumbers(arg3)..' : '..format(ABSORB_TRAILER, arg4)
            end
            -- HEAL OR HOT CRIT
        elseif messageType == 'HEAL_CRIT' or messageType == 'PERIODIC_HEAL_CRIT' then
            displayType = 'plus'
            if COMBAT_TEXT_SHOW_FRIENDLY_NAMES == '1' and UnitName(self.unit) ~= data then
                message = '> '..BreakUpLargeNumbers(arg3)..' : '..data..'!'
            else
                message = '> '..BreakUpLargeNumbers(arg3)..'!'
            end
            -- HEAL OR HOT CRIT + SHIELD
        elseif messageType == 'HEAL_CRIT_ABSORB' then
            displayType = 'plus'
            if COMBAT_TEXT_SHOW_FRIENDLY_NAMES == '1' and UnitName(self.unit) ~= data then
                message = '> '..BreakUpLargeNumbers(arg3)..' : '..data..'! '..format(ABSORB_TRAILER, arg4)
            else
                message = '> '..BreakUpLargeNumbers(arg3)..'! '..format(ABSORB_TRAILER, arg4)
            end
            -- POWER
        elseif messageType == 'ENERGIZE' or messageType == 'PERIODIC_ENERGIZE' then
            displayType = 'plus'
            local count =  tonumber(data)
            if count > 0 then data = '+ '..BreakUpLargeNumbers(data) end
            if arg3 == 'MANA' or arg3 == 'RAGE' or arg3 == 'FOCUS' or arg3 == 'ENERGY'
            or arg3 == 'RUNIC_POWER' or arg3 == 'SOUL_SHARDS' or arg3 == 'CHI' or arg3 == 'DEMONIC_FURY' then
                message = data..' '.._G[arg3]
                info = PowerBarColor[arg3]
            elseif arg3 == 'HOLY_POWER' then
                local numHolyPower = UnitPower(PaladinPowerBar:GetParent().unit, SPELL_POWER_HOLY_POWER)
                message = numHolyPower..' '.._G[arg3]
                info = PowerBarColor[arg3]
            elseif arg3 == 'ECLIPSE' then
                if count < 0 then
                    message = '> '..abs(count)..' '..BALANCE_NEGATIVE_ENERGY
                    info = PowerBarColor[arg3].negative
                else
                    message = data..' '..BALANCE_POSITIVE_ENERGY
                    info = PowerBarColor[arg3].positive
                end
            end
            -- REPUTATION GAIN
        elseif messageType == 'FACTION' then
            displayType = 'minus'
            if tonumber(arg3) > 0 then arg3 = '> '..arg3 end
            message = '> '..data..' '..arg3..''
            -- MISSED
        elseif messageType == 'SPELL_MISS' then
            displayType = 'minus' message = COMBAT_TEXT_MISS
            -- DODGED
        elseif messageType == 'SPELL_DODGE' then
            displayType = 'minus' message = COMBAT_TEXT_DODGE
            -- PARRIED
        elseif messageType == 'SPELL_PARRY' then
            displayType = 'minus' message = COMBAT_TEXT_PARRY
            -- EVADED
        elseif messageType == 'SPELL_EVADE' then
            displayType = 'minus' message = COMBAT_TEXT_EVADE
            -- IMMUNE
        elseif messageType == 'SPELL_IMMUNE' then
            displayType = 'minus' message = COMBAT_TEXT_IMMUNE
            -- DEFLECTED
        elseif messageType == 'SPELL_DEFLECT' then
            displayType = 'minus' message = COMBAT_TEXT_DEFLECT
            -- REFLECTED
        elseif messageType == 'SPELL_REFLECT' then
            displayType = 'minus' message = COMBAT_TEXT_REFLECT
            -- BLOCKED
        elseif messageType == 'BLOCK' or messageType == 'SPELL_BLOCK' then
            displayType = 'minus'
            if arg3 then
                -- PARTIAL BLOCK
                message = '- '..data..' '..format(BLOCK_TRAILER, arg3)
            else message = COMBAT_TEXT_BLOCK end
            -- SHIELD
        elseif messageType == 'ABSORB' or messageType == 'SPELL_ABSORB' then
            displayType = 'minus'
            if arg3 and data > 0 then
                -- PARTIAL SHIELD
                message = '- '..data..' '..format(ABSORB_TRAILER, arg3)
            else message = COMBAT_TEXT_ABSORB end
            -- RESISTED
        elseif messageType == 'RESIST' or messageType == 'SPELL_RESIST' then
            displayType = 'minus'
            if arg3 then
                -- PARTIAL RESIST
                message = '- '..data..' '..format(RESIST_TRAILER, arg3)
            else message = COMBAT_TEXT_RESIST end
            -- HONOUR GAIN
        elseif messageType == 'HONOR_GAINED' then
            displayType = 'plus'
            data = tonumber(data)
            if not data or abs(data) < 1 then return end
            data = floor(data)
            if data > 0 then data = '+ '..data end
            message = format(COMBAT_TEXT_HONOR_GAINED, data)
            -- ACTIVE AURA OR SPELL
        elseif messageType == 'SPELL_ACTIVE' then
            displayType = 'plus'
            message = '> '..data..''
            -- COMBOPOINTS
        elseif messageType == 'COMBO_POINTS' then
            displayType = 'plus'
            message = format(COMBAT_TEXT_COMBO_POINTS, data)
            -- DEATHKNIGHT RUNES
        elseif messageType == 'RUNE' then
            if data == true then
                displayType = 'plus'
                local rune = GetRuneType(arg1)
                message = COMBAT_TEXT_RUNE[rune]
                    -- #freeAlexBrazie
                if rune == 1 then
                    info.r = .75 info.g = 0 info.b = 0
                elseif rune == 2 then
                    info.r = .75 info.g = 1 info.b = 0
                elseif rune == 3 then
                    info.r = 0 info.g = 1 info.b = 1
                end
            else message = nil end
            -- I... DONT KNOW
            -- SHIELD RELATED
        elseif messageType == 'ABSORB_ADDED' then
            displayType = 'plus'
            if COMBAT_TEXT_SHOW_FRIENDLY_NAMES == '1' and UnitName(self.unit) ~= data then
                message = '> '..BreakUpLargeNumbers(arg3)..' — '..COMBAT_TEXT_ABSORB..' : '..data
            else
                message = '> '..BreakUpLargeNumbers(arg3)..' — '..COMBAT_TEXT_ABSORB
            end
            -- FALLBACK
        else
            displayType = 'plus'
            message = _G['COMBAT_TEXT_'..messageType]
            if not message then displayType = 'plus' message = _G[messageType] end
        end

        -- ...GO
        if message then
            CombatText_AddMessage(message, COMBAT_TEXT_SCROLL_FUNCTION, info.r, info.g, info.b, displayType, isStaggered)
        end
    end

    local modCT_Update = function()
        local _, y
        for index, value in pairs(COMBAT_TEXT_TO_ANIMATE) do
			_, y = value.scrollFunction(value)
            if value.dType == 'minus' then
                -- print(value.dType)
                value:SetPoint('TOP', WorldFrame, 'BOTTOM', -190, y + 100)
                value:SetJustifyH'LEFT'
            elseif value.dType == 'plus' then
                value:SetPoint('TOP', WorldFrame, 'BOTTOM', 190, y + 100)
                value:SetJustifyH'RIGHT'
            else
                value:SetJustifyH'LEFT'
                value:SetPoint('TOP', WorldFrame, 'BOTTOM', -190, y + 100)
            end
        end
    end

--[[    function CombatText_StandardScroll(value)
        -- Calculate x and y positions
        local xPos = -200
        local yPos = value.startY + ((value.endY - COMBAT_TEXT_LOCATIONS.startY)*value.scrollTime/COMBAT_TEXT_SCROLLSPEED)
        return xPos, yPos
end ]]


    local modCT_AddMessage = function(message, scrollFunction, r, g, b, displayType, isStaggered)
        local string, noStringsAvailable = CombatText_GetAvailableString()
        if noStringsAvailable then return end
        string.dType = nil
        string.dType = displayType
        string:SetText(message)
        string:SetTextColor(r, g, b)
        modCT_Update()
        -- tinsert(COMBAT_TEXT_TO_ANIMATE, string)
    end

    CombatText:SetScript('OnEvent', modCT_OnEvent)
    hooksecurefunc('CombatText_AddMessage', modCT_AddMessage)
    CombatText:HookScript('OnUpdate', modCT_Update)
