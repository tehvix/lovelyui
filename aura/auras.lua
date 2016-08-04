

    local scale   = 1
    local size    = 26
    local r, g, b = 103/255, 103/255, 103/255
    local aura    = CreateFrame'Frame'

    local BACKDROP = {
    	bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
    	tiled = false,
    	insets = {left = -1, right = -1, top = -1, bottom = -1}
    }
    local BORDER = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        edgeFile = [[Interface\Buttons\WHITE8x8]],
        edgeSize = 1,
    }

    BUFF_FLASH_TIME_ON  = .25
    BUFF_FLASH_TIME_OFF = .25
    BUFF_MIN_ALPHA      = .7
    BUFF_HORIZ_SPACING  = -10

    -- abbreviate duration
    function SecondsToTimeAbbrev(time)
        local hr, m, s, text
        if time <= 0 then
            text = ''
        elseif time < 3600 and time > 60 then
            hr = floor(time/3600)
            m = floor(mod(time, 3600)/60 + 1)
            text = format('%dm', m)
        elseif time < 60 then
            m = floor(time/60)
            s = mod(time, 60)
            text = m == 0 and format('%ds', s)
        else
            hr = floor(time/3600 + 1)
            text = format('%dh', hr)
        end
        return text
     end

    -- scan
    function aura:runthroughicons()
         local i = 1
         while _G['BuffButton'..i] do
             aura:checkgloss('BuffButton'..i, 1)
             i = i + 1
         end
         i = 1
         while _G['DebuffButton'..i] do
             aura:checkgloss('DebuffButton'..i, 2)
             i = i + 1
         end
         i = 1
         while _G['TempEnchant'..i] do
             aura:checkgloss('TempEnchant'..i, 3)
             i = i + 1
         end
     end

    -- style
    function aura:checkgloss(name, icontype)
        local f     = _G[name]
        local bu    = _G[name..'Border']
        local icon  = _G[name..'Icon']
        local time  = _G[name..'Duration']
        local count = _G[name..'Count']

        f:SetSize(size, size)

        if not f.bg then
            f.bg = CreateFrame('Frame', nil, f)
            f.bg:SetPoint('TOPLEFT', -2, 2)
            f.bg:SetPoint('BOTTOMRIGHT', 2, -2)
            f.bg:SetBackdrop(BACKDROP)
            f.bg:SetBackdropColor(0, 0, 0, 1)

            f.bo = CreateFrame('Frame', nil, f)
            f.bo:SetAllPoints(icon)
            f.bo:SetFrameLevel(5)
            f.bo:SetBackdrop(BORDER)
            f.bo:SetBackdropColor(0, 0, 0, 0)
        end

        icon:SetParent(f.bg)
        icon:SetDrawLayer'OVERLAY'
        icon:SetTexCoord(.1, .9, .1, .9)

        time:SetParent(f.bg)
        time:SetFont([[Fonts\ARIALN.ttf]], 9)
	    time:SetShadowOffset(1.7, -1.2)
	    time:SetShadowColor(0, 0, 0)
	    time:SetDrawLayer('OVERLAY', 7)
        time:ClearAllPoints()
        time:SetPoint('TOPRIGHT', f, 'BOTTOMRIGHT', 0, -4)

        count:SetParent(f.bg)
        count:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
        count:SetShadowOffset(0,0)
        count:SetDrawLayer('OVERLAY', 8)
        count:ClearAllPoints()
        count:SetPoint('CENTER', f, 'BOTTOM')

        if icontype == 2 and bu then
            local r, g, b = bu:GetVertexColor()
            f.bo:SetBackdropBorderColor(r, g, b, .8)
        elseif icontype == 3 and bu then
            f.bo:SetBackdropBorderColor(.5, 0, .5, .8)
        else
            f.bo:SetBackdropBorderColor(0, 0, 0, 0)
        end

        if bu then bu:SetAlpha(0) end
    end

    -- position
    hooksecurefunc('BuffFrame_UpdateAllBuffAnchors', function()
        local slack = BuffFrame.numEnchants
        local num   = 0
        local prev, index
        for i = 1, BUFF_ACTUAL_DISPLAY do
            local buff = _G['BuffButton'..i]
            local temp = TemporaryEnchantFrame
            local bf   = BuffFrame

            num   = num + 1
            index = num + slack

            if index > 1 and (mod(index, BUFFS_PER_ROW) == 1) then
            elseif index == 1 then
            else
                if num ~= 1 then
                    buff:ClearAllPoints()
                    buff:SetPoint('LEFT', prev, 'RIGHT', 3, 0)
                end
            end

            if bf.numEnchants > 0 then
                temp:ClearAllPoints()
                temp:SetPoint('TOPLEFT', UIParent, 25, -35)
                temp:SetScale(scale)
                if i == 1 then buff:SetPoint('TOPLEFT', temp, 'TOPRIGHT', 15, 0) end
            else
                bf:ClearAllPoints()
                bf:SetPoint('TOPLEFT', UIParent, 15, -35)
                bf:SetScale(scale)
            end
            prev = buff
        end
    end)

    -- move debuffs
    --[[ hooksecurefunc('DebuffButton_UpdateAnchors', function(self, index)
        local numBuffs = BUFF_ACTUAL_DISPLAY + BuffFrame.numEnchants
        local rowSpacing
        local debuffSpace = mysize + 6
        if ShouldShowConsolidatedBuffFrame() then
            numBuffs = numBuffs + 1
        end
        local numRows = ceil(numBuffs/BUFFS_PER_ROW)

        if numRows and numRows > 1 then
            rowSpacing = -numRows*debuffSpace
        else
            rowSpacing = -debuffSpace
        end

        local db = _G[self..index]
        db.ignoreFramePositionManager = true

        db:ClearAllPoints()
            -- make first row
        if index == 1 then
            db:SetPoint('TOPLEFT', ConsolidatedBuffs, 'BOTTOMLEFT', 0, rowSpacing + 24)
                -- or a new row below if we've got 8+ (tip: you're gonna die)
        elseif index >= 2 and mod(index, BUFFS_PER_ROW) == 1 then
            db:SetPoint('TOP', _G[self..(index - BUFFS_PER_ROW)], 'BOTTOM', 0, -12)
                -- or just place them beside the last debuff
        else
            db:SetPoint('TOPRIGHT', _G[self..(index - 1)], 'TOPLEFT', -6, 0)
        end
    end) ]]

    hooksecurefunc('AuraButton_Update', function() aura:runthroughicons() end)


    --
