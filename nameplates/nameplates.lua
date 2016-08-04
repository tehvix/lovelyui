

    local addon, ns = ...

    -- print(addon)

    local r, g, b  = 103/255, 103/255, 103/255
    local TEXTURE  = [[Interface\AddOns\lovelyui\art\statusbar.tga]]
    local BACKDROP = {
        bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
        tiled = false,
        insets = {left = -3, right = -3, top = -3, bottom = -3}
    }
    local MANA_BACKDROP = {
        bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
        tiled = false,
        insets = {left = -3, right = -3, top = 0, bottom = -3}
    }

    local options = function()
        local _, class = UnitClass'player'
        local colour   = RAID_CLASS_COLORS[class]
        DefaultCompactNamePlateFrameSetUpOptions['healthBarHeight'] = 6
        DefaultCompactNamePlatePlayerFrameOptions['healthBarColorOverride'] = CreateColor(colour.r, colour.g, colour.b)
        for _, v in pairs({'Enemy', 'Friendly'}) do
            for _, j in pairs({'selectedBorderColor', 'tankBorderColor', 'defaultBorderColor'}) do
                _G['DefaultCompactNamePlate'..v..'FrameOptions'][j] = CreateColor(0, 0, 0, 0)
            end
            for _, j in pairs({'displayNameWhenSelected', 'displayNameByPlayerNameRules'}) do
                _G['DefaultCompactNamePlate'..v..'FrameOptions'][j] = false
            end
        end
    end

    local flag = function(unit)
        local base  = C_NamePlate.GetNamePlateForUnit(unit)
        local frame = base.UnitFrame

        local c = UnitClassification(unit)
        local q = UnitIsQuestBoss(unit)

        frame.classificationIndicator:Hide()

        if frame.flag then
            if  c == 'worldboss' then
                frame.flag:SetAtlas'worldquest-icon-pvp-ffa'
                frame.flag:SetSize(15, 15)
                frame.flag:SetDesaturated(false)
                frame.flag:Show()
            elseif c == 'elite' or c == 'rareelite' or c == 'rare' then
                frame.flag:SetAtlas'worldquest-questmarker-dragon'
                frame.flag:SetSize(20, 20)
                frame.flag:Show()
                if c == 'elite' then frame.flag:SetDesaturated(false) else frame.flag:SetDesaturated(true) end
            elseif q then
                frame.flag:SetAtlas'worldquest-questmarker-questbang'
                frame.flag:SetSize(6, 15)
                frame.flag:SetDesaturated(false)
                frame.flag:Show()
            else
                frame.flag:SetAtlas''
                frame.flag:SetDesaturated(false)
                frame.flag:Hide()
            end
        end
    end

    local player = function(unit)
        if UnitIsUnit('player', unit) then
            local parent = _G['lovelyui_container']
            local base   = C_NamePlate.GetNamePlateForUnit(unit)
            local frame  = base.UnitFrame
            parent:ClearAllPoints()
            parent:SetPoint('TOP', frame, 'BOTTOM', 0, 5)
            frame:HookScript('OnHide', function()
                parent:ClearAllPoints()
                parent:SetPoint('BOTTOM', 0, 155)
            end)
        end
    end

    local buffs = function(self)
        local f = self:GetParent()
        for i = 1, 4 do
            local bu = _G[f:GetName()..'Buff'..i]
            if  bu and not bu.skinned then
                bu:SetSize(18, 12)
                bu:SetBackdrop(BACKDROP)
                bu:SetBackdropColor(0, 0, 0, 1)
                bu.skinned = true
            end
        end
    end

    local mana = function(self)
        self:SetHeight(6)
        -- self.SetHeight = function() end
        self:SetStatusBarTexture(TEXTURE)
        self:SetBackdrop(MANA_BACKDROP)
        self:SetBackdropColor(0, 0, 0, 1)
    end

    local name = function(frame)
        if frame.name:IsShown() then
            local unit = frame.displayedUnit
            if UnitIsPlayer(unit) then
                local _, class = UnitClass(frame.displayedUnit)
                local colour   = RAID_CLASS_COLORS[class]
                if colour then frame.name:SetTextColor(colour.r, colour.g, colour.b) end
            end
        end
    end

    local style = function(frame)
       if frame.styled then return end
       frame.healthBar:SetStatusBarTexture(TEXTURE)
       frame.healthBar:SetBackdrop(BACKDROP)
       frame.healthBar:SetBackdropColor(0, 0, 0, 1)

       frame.name:SetFont([[Fonts\skurri.ttf]], 13)

       frame.selectionHighlight:SetTexture''
       frame.aggroHighlight:SetTexture''

       frame.shadow = frame:CreateTexture(nil, 'BACKGROUND')
       frame.shadow:SetSize(100, 18)
       frame.shadow:SetAlpha(.7)
       frame.shadow:SetAtlas'legionmission-hearts-background'
       frame.shadow:SetPoint('TOP', frame.healthBar)

       frame.flag = frame.healthBar:CreateTexture(nil, 'OVERLAY')
       frame.flag:SetPoint('RIGHT', frame.healthBar, 4, 0)
       frame.flag:Hide()

       frame.RaidTargetFrame.RaidTargetIcon:SetSize(15, 15)
       frame.RaidTargetFrame.RaidTargetIcon:SetParent(frame.healthBar)
       frame.RaidTargetFrame.RaidTargetIcon:ClearAllPoints()
       frame.RaidTargetFrame.RaidTargetIcon:SetPoint('LEFT', frame.healthBar, 2, 4)
       frame.RaidTargetFrame.RaidTargetIcon:SetDrawLayer'OVERLAY'

       mana(ClassNameplateManaBarFrame)
       hooksecurefunc('CompactUnitFrame_UpdateName', name)
       hooksecurefunc(frame.BuffFrame, 'UpdateBuffs', buffs)
       hooksecurefunc(ClassNameplateManaBarFrame, 'OnOptionsUpdated', mana)

       frame.styled = true
   end

    local castbar = function(frame)
        frame.castBar:SetHeight(6)
        frame.castBar:ClearAllPoints()
        frame.castBar:SetPoint('BOTTOMLEFT', frame, 12, 5)
        frame.castBar:SetPoint('BOTTOMRIGHT', frame, -12, 5)
        frame.castBar:SetStatusBarTexture(TEXTURE)
        frame.castBar:SetBackdrop(BACKDROP)
        frame.castBar:SetBackdropColor(0, 0, 0, 1)

        frame.castBar.Text:ClearAllPoints()
        frame.castBar.Text:SetPoint('TOP', frame.castBar, 'BOTTOM')
        frame.castBar.Text:SetFont(STANDARD_TEXT_FONT, 9)
        frame.castBar.Text:SetShadowOffset(1, -1)
	    frame.castBar.Text:SetShadowColor(0, 0, 0, 1)

        frame.castBar.Icon:SetSize(14, 14)
        frame.castBar.Icon:ClearAllPoints()
        frame.castBar.Icon:SetPoint('TOPRIGHT', frame.healthBar, 'TOPLEFT', -3, 0)
        frame.castBar.Icon:SetTexCoord(.1, .9, .1, .9)

        frame.castBar.BorderShield:SetSize(16, 16)
        frame.castBar.BorderShield:ClearAllPoints()
        frame.castBar.BorderShield:SetPoint('CENTER', frame.castBar.Icon)

        if not frame.castBar.Icon.bg then
            frame.castBar.Icon.bg = CreateFrame('Frame', nil, frame.castBar)
            frame.castBar.Icon.bg:SetAllPoints(frame.castBar.Icon)
            frame.castBar.Icon.bg:SetBackdrop(BACKDROP)
            frame.castBar.Icon.bg:SetBackdropColor(0, 0, 0, 1)
            frame.castBar.Icon.bg:SetFrameLevel(0)
        end
   end

   hooksecurefunc('DefaultCompactNamePlateFrameSetup', castbar)

    local f = CreateFrame'Frame'
    f:RegisterEvent'NAME_PLATE_CREATED'
    f:SetScript('OnEvent', function(self, event, ...)
        if event == 'NAME_PLATE_CREATED' then
            f:RegisterEvent'NAME_PLATE_UNIT_ADDED'
            local base = ...
            style(base.UnitFrame)
            options()
        else
            local unit = ...
            flag(unit)
            player(unit)
        end
    end)


    --
