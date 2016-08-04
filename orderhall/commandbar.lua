

    local TEXTURE = [[Interface\AddOns\lovelyui\art\statusbar]]

    local follower = function(self)
        local info = C_Garrison.GetClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)
        for i, v in ipairs(info) do
            local frame = self.categoryPool:Acquire()
            local x  = {frame.Icon:GetPoint()}
            local xx = {frame.Count:GetPoint()}
            if not frame.moved then
                frame.Icon:ClearAllPoints()
                frame.Icon:SetPoint(x[1], x[2], x[3], x[4] + 40, x[5] + 9)
                frame.Icon:SetSize(36, 16)
                frame.TroopPortraitCover:Hide()
                frame.Count:SetFont(STANDARD_TEXT_FONT, 10)
                frame.Count:SetTextColor(1, 1, 1)
                frame.Count:ClearAllPoints()
                frame.Count:SetPoint('RIGHT', xx[2], 'LEFT', xx[4] - 50, x[5] - 2)
                frame.moved = true
            end
        end
    end

    local f = CreateFrame'Frame'
    f:RegisterEvent'ADDON_LOADED'
    f:SetScript('OnEvent', function(self, event, addon)
        if addon == 'Blizzard_OrderHallUI' then
            OrderHallCommandBar.Background:Hide()

            OrderHallCommandBar.ClassIcon:Hide()

            OrderHallCommandBar.AreaName:SetFont(STANDARD_TEXT_FONT, 10)
            OrderHallCommandBar.AreaName:ClearAllPoints()
            OrderHallCommandBar.AreaName:SetPoint('TOP', OrderHallCommandBar, 0, -2)

            OrderHallCommandBar.Currency:SetFont(STANDARD_TEXT_FONT, 10)
            OrderHallCommandBar.Currency:ClearAllPoints()
            OrderHallCommandBar.Currency:SetPoint('TOPLEFT', OrderHallCommandBar, 100, -2)

            OrderHallCommandBar.CurrencyIcon:SetSize(16, 16)
            OrderHallCommandBar.CurrencyIcon:ClearAllPoints()
            OrderHallCommandBar.CurrencyIcon:SetPoint('TOPLEFT', 40, 0)

            OrderHallCommandBar.WorldMapButton:Hide()

            local bottom = OrderHallCommandBar:CreateTexture(nil, 'ARTWORK')
            bottom:SetTexture(TEXTURE)
            bottom:SetHeight(3)
            bottom:SetPoint('BOTTOMLEFT',  OrderHallCommandBar, 0, 8)
            bottom:SetPoint('BOTTOMRIGHT', OrderHallCommandBar, 0, 8)
            bottom:SetVertexColor(0, 0, 0)

            hooksecurefunc(OrderHallCommandBar, 'RequestCategoryInfo', follower)
            hooksecurefunc(OrderHallCommandBar, 'RefreshCategories',   follower)

            f:UnregisterAllEvents()
        end
    end)


    --
