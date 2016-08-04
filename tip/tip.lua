
                        -- tooltip mod
                        -- with some bits pinched from an ancient (early-WOTLK!) version of rantTooltip
                        -- credits to Rummie
                        -- obble


        -- default tooltip position
    local TipPosition = {'BOTTOMRIGHT', _G['modbar'], 'BOTTOMRIGHT', -40, 40}

        -- set tooltip scale (between 0 - 1)
    local scale = 1

        -- hide/show player titles
    local hidetitles = true

    local RAID_CLASS_COLORS = RAID_CLASS_COLORS
    local FACTION_BAR_COLORS = FACTION_BAR_COLORS
    local r, g, b = 103/255, 103/255, 103/255
    local WorldFrame = WorldFrame
    local GameTooltip = GameTooltip
    local GameTooltipStatusBar = GameTooltipStatusBar
    local TEXTURE = [[Interface\AddOns\lovelyui\art\statusbar]]
    local BACKDROP = {
        bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
        tiled = false,
        insets = {left = -3, right = -3, top = -3, bottom = -3}
    }


        -- TEXT
    GameTooltipHeaderText:SetFont(STANDARD_TEXT_FONT, 12)
    GameTooltipHeaderText:SetShadowOffset(.7, -.7)
    GameTooltipHeaderText:SetShadowColor(0, 0, 0, 1)
    GameTooltipText:SetFont(STANDARD_TEXT_FONT, 11)
    GameTooltipText:SetShadowOffset(.7, -.7)
    GameTooltipText:SetShadowColor(0, 0, 0,1)
    Tooltip_Small:SetFont(STANDARD_TEXT_FONT, 11)
    Tooltip_Small:SetShadowOffset(.7, -.7)
    Tooltip_Small:SetShadowColor(0, 0, 0, 1)


        -- HP BAR
    GameTooltipStatusBar:SetStatusBarTexture(TEXTURE)

    GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil, 'BACKGROUND')
    GameTooltipStatusBar.bg:SetTexture(TEXTURE)
    GameTooltipStatusBar.bg:SetAllPoints()

    GameTooltip:HookScript('OnTooltipCleared', GameTooltip_ClearStatusBars)


        -- POSITION
    local tip_Offset = function(self, elapsed)  -- uuuuugly cursor hax
        local unitname = self:GetUnit()         -- to allow us to offset unit tips w/ bag open
        if unitname ~= nil then
            local scale = self:GetEffectiveScale()
            local x, y = GetCursorPosition()
            local currentOffsetX, currentOffsetY = -150, 20
            x, y = x/scale + currentOffsetX, y/scale + currentOffsetY
            self:ClearAllPoints()
            self:SetPoint('BOTTOMLEFT', UIParent, x, y)
        end
    end

    hooksecurefunc('GameTooltip_SetDefaultAnchor', function(tooltip, parent)
        if  cursor and GetMouseFocus() == WorldFrame then
            tooltip:SetOwner(parent, 'ANCHOR_CURSOR')
        else
            tooltip:ClearAllPoints()
            tooltip:SetParent(_G['modbar'])
            tooltip:SetOwner(_G['modbar'], 'ANCHOR_TOPRIGHT', -40, 40)
                -- anchor to cursor if bag is shown
            if  ContainerFrame1:IsShown() then
                tooltip:SetAnchorType'ANCHOR_CURSOR'
                GameTooltipStatusBar:ClearAllPoints()   -- reposition hp bar left of tooltip
                GameTooltipStatusBar:SetPoint('TOPLEFT', tooltip, -16, -6)
                GameTooltipStatusBar:SetPoint('BOTTOMRIGHT', tooltip, 'BOTTOMLEFT', -10, 6)
                GameTooltipStatusBar:SetOrientation'VERTICAL'
                GameTooltipStatusBar:SetRotatesTexture(true)
                tooltip:SetScript('OnUpdate', tip_Offset)
                -- otherwise position based on actionbars
            else
                GameTooltipStatusBar:ClearAllPoints()
                GameTooltipStatusBar:SetPoint('TOPLEFT', tooltip, 0, 5)
                GameTooltipStatusBar:SetPoint('BOTTOMRIGHT', tooltip, 'TOPRIGHT')
                GameTooltipStatusBar:SetOrientation'HORIZONTAL'
                GameTooltipStatusBar:SetRotatesTexture(false)
                tooltip:SetPoint(TipPosition[1], TipPosition[2], TipPosition[3], TipPosition[4], TipPosition[5])
                tooltip:SetScript('OnUpdate', nil)
            end
        end
    end)


        -- CASTER
    local AddCasterRow = function(tooltip, caster)
        tooltip:AddDoubleLine('|cff0099ffCaster|r', caster)
        tooltip:Show()
    end


        -- ILVL
    local SlotName = {
	    'Head', 'Neck', 'Shoulder', 'Back', 'Chest', 'Wrist',
	    'Hands', 'Waist', 'Legs', 'Feet', 'Finger0', 'Finger1',
	    'Trinket0', 'Trinket1', 'MainHand', 'SecondaryHand'
    }

    local AddInspectInfo = function(unit)
    	local total, item = 0, 0
    	for k, v in pairs(SlotName) do
        	local slot = GetInventoryItemLink(unit, GetInventorySlotInfo(v..'Slot'))
        	if slot ~= nil then
            	item = item + 1
            	total = total + select(4, GetItemInfo(slot))
        	end
    	end
    	if item > 0 then return floor(total/item) end
    	return 0
	end


        -- AURAS
    local AddSpellIdRow = function(tooltip, spellid)
        tooltip:AddDoubleLine('|cff0099ffSpell ID|r', spellid)
        tooltip:Show()
    end

    GameTooltip:HookScript('OnTooltipSetSpell', function(self)
        local spellid = select(3, self:GetSpell())
        if spellid then AddSpellIdRow(self, spellid) end
    end)

        -- boss debuff
    local AddBossDebuffRow = function(tooltip, isBossDebuff)
        tooltip:AddDoubleLine('|cff0099ffBossDebuff|r', 'Yes')
        tooltip:Show()
    end

    hooksecurefunc(GameTooltip, 'SetUnitBuff', function(self,...)
        local spellid = select(11, UnitBuff(...))
        if spellid then AddSpellIdRow(self, spellid) end

        local caster = select(8, UnitBuff(...))
        AddCasterRow(self,select(8, UnitBuff(...)), select(13, UnitBuff(...)))
    end)

    hooksecurefunc(GameTooltip, 'SetUnitDebuff', function(self,...)
        local spellid = select(11, UnitDebuff(...))
        if spellid then AddSpellIdRow(self, spellid) end

        local caster = select(8, UnitDebuff(...))
        if caster then AddCasterRow(self, caster) end

        local isBossDebuff = select(13, UnitDebuff(...))
        if isBossDebuff then AddBossDebuffRow(self,isBossDebuff) end
    end)

    hooksecurefunc(GameTooltip, 'SetUnitAura', function(self,...)
        local spellid = select(11, UnitAura(...))
        if spellid then AddSpellIdRow(self, spellid) end

        local caster = select(8, UnitAura(...))
        if caster then AddCasterRow(self, caster) end

        local isBossDebuff = select(13, UnitAura(...))
        if isBossDebuff then AddBossDebuffRow(self,isBossDebuff) end
    end)


        -- ITEM
    hooksecurefunc('SetItemRef', function(link, text, button, chatFrame)
        if string.find(link, '^spell:') then
            local spellid = string.sub(link, 7)
            AddSpellIdRow(ItemRefTooltip, spellid)
       end
    end)


        -- LEVEL
    local GetFormattedUnitLevel = function(unit)
        local diff = GetQuestDifficultyColor(UnitLevel(unit))
        if UnitLevel(unit) == -1 then
            return '|cffff0000??|r '
        elseif UnitLevel(unit) == 0 then
            return '? '
        else
            return format(' lvl '..'|cff%02x%02x%02x%s|r ', diff.r*255, diff.g*255, diff.b*255, UnitLevel(unit))
        end
    end


        -- CLASS
    local GetFormattedUnitClass = function(unit)
        local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
        if color then
            return format(' |cff%02x%02x%02x%s|r', color.r*255, color.g*255, color.b*255, UnitClass(unit))
        end
    end


        -- MOB TYPE
    local GetFormattedUnitType = function(unit)
        local creaturetype = UnitCreatureType(unit)
        if creaturetype then return creaturetype
        else return ''
        end
    end


        -- CREATE LEVEL/RACE/CLASS/TYPE STRING
   local GetFormattedLevelString = function(unit, specIcon)
        if UnitIsPlayer(unit) then
            if not UnitRace(unit) then return nil end
            return (specIcon or '')..GetFormattedUnitLevel(unit)..UnitRace(unit)..GetFormattedUnitClass(unit)
        else
            return GetFormattedUnitLevel(unit)..GetFormattedUnitType(unit)
        end
    end


        -- COLOURING NAME
    local GetHexColor = function(colour)
        return ('%.2x%.2x%.2x'):format(colour.r*255, colour.g*255, colour.b*255)
    end

    local classColors = {}
    for class, color in pairs(RAID_CLASS_COLORS) do
        classColors[class] = GetHexColor(RAID_CLASS_COLORS[class])
    end

    local reactionColors = {}
    for i = 1, #FACTION_BAR_COLORS do
        reactionColors[i] = GetHexColor(FACTION_BAR_COLORS[i])
    end


        -- TARGET
    local GetTarget = function(unit)
        if UnitIsUnit(unit, 'player') then
            return ('|cffff0000%s|r'):format('/YOU/')
        elseif UnitIsPlayer(unit, 'player')then
            return ('|cff%s%s|r'):format(classColors[select(2, UnitClass(unit))], UnitName(unit))
        elseif UnitIsPlayer(unit, 'player') and UnitFactionGroup(unit) == 'Horde' then
            return (' |TInterface\\AddOns\\lovelyui\\tip\\texture\\horde.tga:12:12|t'..'|cff%s%s|r'):format(classColors[select(2, UnitClass(unit))], UnitName(unit))
        elseif UnitIsPlayer(unit, 'player') and UnitFactionGroup(unit) == 'Alliance' then
            return (' |TInterface\\AddOns\\lovelyui\\tip\\texture\\alliance.tga:12:12|t '..'|cff%s%s|r'):format(classColors[select(2, UnitClass(unit))], UnitName(unit))
        elseif UnitReaction(unit, 'player') then
            return ('|cff%s%s|r'):format(reactionColors[UnitReaction(unit, 'player')], UnitName(unit))
        else
            return ('|cffffffff%s|r'):format(UnitName(unit))
        end
    end


        -- SET-UP UNIT TOOLTIP
    GameTooltip.inspectCache = {}
    GameTooltip:HookScript('OnTooltipSetUnit', function(self,...)
        local unit = select(2, self:GetUnit()) or (GetMouseFocus() and GetMouseFocus():GetAttribute('unit')) or (UnitExists('mouseover') and 'mouseover')
        if not unit or (unit and type(unit) ~= 'string') then return end
        if not UnitGUID(unit) then return end

            -- colour sb bg
        local red, green, blue = GameTooltipStatusBar:GetStatusBarColor()
        GameTooltipStatusBar.bg:SetVertexColor(red*.75, green*.75, blue*.75)

            -- reaction colour
        local unitReaction = FACTION_BAR_COLORS[UnitReaction(unit, 'player')] and FACTION_BAR_COLORS[UnitReaction(unit, 'player')] or { r = .5, g = .5, b = .5 }

            -- raid icons
        local ricon = GetRaidTargetIndex(unit)
        if ricon then
            local text = GameTooltipTextLeft1:GetText()
            GameTooltipTextLeft1:SetText(('%s %s'):format(ICON_LIST[ricon]..'14|t', text))
        end

            -- hide/show titles
        local title = UnitPVPName(unit)
        local name = UnitName(unit)
        local relationship = UnitRealmRelationship(unit)
        local faction = UnitFactionGroup(unit) == FACTION_HORDE and '|TInterface\\AddOns\\lovelyui\\tip\\texture\\horde.tga:12:12|t ' or UnitFactionGroup(unit) == FACTION_ALLIANCE and '|TInterface\\AddOns\\lovelyui\\tip\\texture\\alliance.tga:12:12|t ' or ''
        local flag = UnitIsAFK(unit) and ' |cff00ff00'..CHAT_FLAG_AFK..'|r' or UnitIsDND(unit) and ' |cff00ff00'..CHAT_FLAG_DND..'|r' or ''

        if title and hidetitles then
            GameTooltipTextLeft1:SetText(faction..flag..name..((relationship == 2 or relationship == 3) and ' —' or ''))
        else
            GameTooltipTextLeft1:SetText(faction..flag..name)
        end

        for i = 2, GameTooltip:NumLines() do
            local line = _G['GameTooltipTextLeft'..i]
            local text = line:GetText()
            if  line then
                -- set default colour for all other lines
                -- and add bullet points
                line:SetText('— '..text)
                line:SetTextColor(.8, .8, .6)

                -- remove faction & pvp flag
                local t = gsub(text, '— (.+)', '%1')
                if t == '' or t == PVP_ENABLED
                or t == FACTION_ALLIANCE or t == FACTION_HORDE then
        			line:SetText(nil)
        		end
            end
        end

            -- flags and reaction colours for name & hp bar
            -- + guild
        if UnitIsPlayer(unit) then
                -- hp & name class colouring
            local _, class = UnitClass(unit)
            local colour = RAID_CLASS_COLORS[class]
            local unitName, unitRealm = UnitName(unit)

            GameTooltipStatusBar:SetStatusBarColor(colour.r, colour.g, colour.b)
            GameTooltipTextLeft1:SetTextColor(colour.r, colour.g, colour.b)

		        -- guild
            local unitGuild = GetGuildInfo(unit)
            local text = GameTooltipTextLeft2:GetText()
            if unitGuild and text and text:find('^'..'— '..unitGuild) then
                GameTooltipTextLeft2:SetTextColor(255/255, 20/255, 200/255)
            end
        else
                -- hp & name reaction colouring
            local reaction = UnitReaction(unit, 'player')
            if reaction then
                local colour = FACTION_BAR_COLORS[reaction]
                if colour then
                     GameTooltipStatusBar:SetStatusBarColor(colour.r, colour.g, colour.b)
                     GameTooltipTextLeft1:SetTextColor(colour.r, colour.g, colour.b)
                end
             end

                 -- boss/elite/rare flags
            local unitClassification = UnitClassification(unit)
            if unitClassification == 'worldboss' or UnitLevel(unit) == -1 then
                 self:AppendText' |TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:14:14|t'
            elseif unitClassification == 'rare' then
                 self:AppendText' |TInterface\\AddOns\\lovelyui\\tip\\texture\\rare:14:14:0:0:16:16:0:15:0:14|t'
            elseif unitClassification == 'rareelite' then
                 self:AppendText' |TInterface\\AddOns\\lovelyui\\tip\\texture\\rare:14:14:0:0:16:16:0:15:0:14|t'
            elseif unitClassification == 'elite' then
                 self:AppendText' |TInterface\\AddOns\\lovelyui\\tip\\texture\\elite:14:14|t'
            end
        end

            -- ghost/dead
        if UnitIsGhost(unit) then
            self:AppendText' |cffaaaaaa/GHOST/|r'
            GameTooltipTextLeft1:SetTextColor(.5, .5, .5)
        elseif UnitIsDead(unit) then
            self:AppendText' |cffaaaaaa/DEAD/|r'
            GameTooltipTextLeft1:SetTextColor(.5, .5, .5)
        end

            -- target
        if UnitExists(unit..'target') then
            GameTooltip:AddDoubleLine('— '..'|cffff9999Target|r:', GetTarget(unit..'target') or 'Unknown')
        end

            -- ilvl/spec
	    local ilvl = 0
        local specIcon = ''
        local lastUpdate = 30
        for index, _ in pairs(self.inspectCache) do
            local inspectCache = self.inspectCache[index]
            if inspectCache.GUID == UnitGUID(unit) then
                ilvl = inspectCache.itemLevel or 0
                specIcon = inspectCache.specIcon or ''
                lastUpdate = inspectCache.lastUpdate and math.abs(inspectCache.lastUpdate - math.floor(GetTime())) or 30
            end
        end

        if unit and CanInspect(unit) then
            if not self.inspectRefresh and lastUpdate >= 30 and not self.blockInspectRequests then
                if not self.blockInspectRequests then
                    self.inspectRequestSent = true
                    NotifyInspect(unit)
                end
            end
        end

        self.inspectRefresh = false

        local name, realm = UnitName(unit)

		if ilvl > 1 then
            GameTooltip:AddLine('— '..STAT_AVERAGE_ITEM_LEVEL..': '.. '|cffFF9093'..ilvl..'|r')
        end

        -- level
        for i = 2, GameTooltip:NumLines() do
            local line = _G['GameTooltipTextLeft'..i]
            local text = line:GetText()
            if line and text and text:find('^'..TOOLTIP_UNIT_LEVEL:gsub('%%s', '.+')) then
                _G['GameTooltipTextLeft'..i]:SetText(GetFormattedLevelString(unit, specIcon))
            end
        end
    end)


        -- STYLE TOOLTIP
    local function TooltipOnShow(self, ...)
        self:SetScale(scale)
        self:SetBackdrop(nil)
        self:SetFrameStrata'TOOLTIP'
        if not self.bg then
            self.bg = CreateFrame('Frame', nil, self)
            if GameTooltipStatusBar:IsShown() and GameTooltipStatusBar:GetValue() >= 0 then
                self.bg:SetPoint('TOPLEFT', GameTooltipStatusBar)
            else
                self.bg:SetPoint('TOPLEFT', self)
            end
            self.bg:SetPoint('BOTTOMRIGHT', self)
            self.bg:SetBackdrop(BACKDROP)
            self.bg:SetBackdropColor(0, 0, 0)
            self.bg:SetFrameLevel(0)
        end
    end

        -- table of tooltips and menus to be modified
    local tooltips = {  GameTooltip,
                        ItemRefTooltip,
                        ItemRefShoppingTooltip1,
                     	ItemRefShoppingTooltip2,
	                    ItemRefShoppingTooltip3,
                        ShoppingTooltip1,
                        ShoppingTooltip2,
                        ShoppingTooltip3,
                        WorldMapTooltip,
                        WorldMapCompareTooltip1,
	                    WorldMapCompareTooltip2,
	                    WorldMapCompareTooltip3,
                        FriendsTooltip,
                        FloatingBattlePetTooltip,
                        FloatingGarrisonFollowerTooltip,
                        FrameStackTooltip,
                      }

    local menus =    {  DropDownList1MenuBackdrop,
                        DropDownList2MenuBackdrop,
                        DropDownList3MenuBackdrop,
                        ChatMenu,
                        EmoteMenu,
                        LanguageMenu,
                        VoiceMacroMenu
                      }

    for i, tooltip in ipairs(tooltips) do
        tooltip:SetClampedToScreen(true)
        tooltip:SetScale(1)
        tooltip:HookScript('OnShow', TooltipOnShow)
    end

    for i, menu in ipairs(menus) do menu:SetScale(1) end


        -- FISHING FOR INSPECT INFO
    GameTooltip:RegisterEvent'INSPECT_READY'
    GameTooltip:SetScript('OnEvent', function(self, event, GUID)
        if not self:IsShown() then return end

        local _, unit = self:GetUnit()
        if not unit then return end

        if self.blockInspectRequests then self.inspectRequestSent = false end

        if UnitGUID(unit) ~= GUID or not self.inspectRequestSent then
            if not self.blockInspectRequests then ClearInspectPlayer() end
            return
        end

        local _, _, _, icon = GetSpecializationInfoByID(GetInspectSpecialization(unit))
        local ilvl = AddInspectInfo(unit)
        local now = GetTime()

        local matchFound
        for index, _ in pairs(self.inspectCache) do
            local inspectCache = self.inspectCache[index]
            if inspectCache.GUID == GUID then
                inspectCache.itemLevel = ilvl
                inspectCache.specIcon = icon and ' |T'..icon..':0|t' or ''
                inspectCache.lastUpdate = math.floor(now)
                matchFound = true
            end
        end

        if not matchFound then
            local GUIDInfo = {
                ['GUID'] = GUID,
                ['itemLevel'] = ilvl,
                ['specIcon'] = icon and ' |T'..icon..':0|t' or '',
                ['lastUpdate'] = math.floor(now)
            }
            table.insert(self.inspectCache, GUIDInfo)
        end

        if #self.inspectCache > 30 then
            table.remove(self.inspectCache, 1)
        end

        self.inspectRefresh = true
        GameTooltip:SetUnit'mouseover'

        if not self.blockInspectRequests then ClearInspectPlayer() end
        self.inspectRequestSent = false
    end)

    local inf = CreateFrame'Frame'
    inf:RegisterEvent'ADDON_LOADED'
    inf:SetScript('OnEvent', function(self, event, addon)
        if addon == 'Blizzard_InspectUI' then
            hooksecurefunc('InspectFrame_Show', function(unit)
                GameTooltip.blockInspectRequests = true
            end)
            InspectFrame:HookScript('OnHide', function()
                GameTooltip.blockInspectRequests = false
            end)
            self:UnregisterEvent'ADDON_LOADED'
        end
    end)
