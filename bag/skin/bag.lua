

                    -- skin bag buttons
                    -- obble

    local r, g, b = 103/255, 103/255, 103/255

    local BACKDROP = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        tiled = false,
        insets = {left = -3, right = -3, top = -3, bottom = -3}
    }
    local SEARCH_BACKDROP = {
        bgFile   = [[Interface\Tooltips\UI-Tooltip-Background]],
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        tiled    = false,
        edgeSize = -3,
        insets   = {left = -3, right = -3, top = -3, bottom = -7}
    }
    local BORDER = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        edgeFile = [[Interface\Buttons\WHITE8x8]],
        edgeSize = 1,
    }


        -- BAG SORT
    BagItemAutoSortButton:GetNormalTexture():SetTexCoord(.2, .8, .2, .8)
    BagItemAutoSortButton:SetBackdrop(BACKDROP)
    BagItemAutoSortButton:SetBackdropColor(0, 0, 0)

        -- BAG SEARCH
    BagItemSearchBox:SetBackdrop(SEARCH_BACKDROP)
    BagItemSearchBox:SetBackdropColor(0, 0, 0)
    BagItemSearchBox:SetBackdropBorderColor(0, 0, 0)
    for _, v in pairs({BagItemSearchBox.Left, BagItemSearchBox.Middle, BagItemSearchBox.Right}) do
        v:Hide()
    end

        -- BAG BUTTONS
    for i = 1, 12 do
        for k = 1, MAX_CONTAINER_ITEMS do
            local f  = 'ContainerFrame'..i..'Item'..k
            local bu = _G[f]
            local cd = _G[f..'Cooldown']
            local co = _G[f..'Count']
            local ic = _G[f..'IconTexture']
            local q  = _G[f..'IconQuestTexture']
            local border = bu.IconBorder
            local junk   = bu.JunkIcon
            local search = bu.searchOverlay
            local new    = bu.NewItemTexture

            bu:SetNormalTexture''
            bu:SetBackdrop(BACKDROP)
            bu:SetBackdropColor(0, 0, 0)

            bu.bo = CreateFrame('Frame', nil, bu)
            bu.bo:SetAllPoints(ic)
            bu.bo:SetFrameLevel(5)
            bu.bo:SetBackdrop(BORDER)
            bu.bo:SetBackdropColor(0, 0, 0, 0)

            ic:SetTexCoord(.1, .9, .1, .9)

            co:SetJustifyH'CENTER'
            co:ClearAllPoints()
            co:SetPoint('BOTTOM', bu, 1, -2)
            co:SetFont(STANDARD_TEXT_FONT, 13, 'OUTLINE')

            border:SetAlpha(0)

            junk:ClearAllPoints()
            junk:SetPoint('CENTER', bu)

            search:SetPoint('TOPLEFT', -2, 2)
            search:SetPoint('BOTTOMRIGHT', 2, -2)
            search:SetDrawLayer('ARTWORK', 7)

            new:ClearAllPoints()
            new:SetPoint('TOPLEFT', 2, -3)
            new:SetPoint('BOTTOMRIGHT', -3, 2)
            new:SetDrawLayer'ARTWORK'

            q:SetDrawLayer'BACKGROUND'
            q:SetSize(1, 1)
        end
    end

        -- backpack tokens
    for i = 1, 3 do
        local bu = _G['BackpackTokenFrameToken'..i]
        local ic = _G['BackpackTokenFrameToken'..i..'Icon']
        local count = _G['BackpackTokenFrameToken'..i..'Count']
        if bu then
            bu:SetBackdrop(BACKDROP)
            bu:SetBackdropColor(0, 0, 0)

            ic:ClearAllPoints()
            ic:SetPoint('RIGHT', bu)
            ic:SetTexCoord(.1, .9, .1, .9)

            count:ClearAllPoints()
            count:SetPoint('RIGHT', ic, 'LEFT', -5, 0)
            count:SetFont(STANDARD_TEXT_FONT, 7)
        end
    end

    for i = 0, 3 do
        local bu = _G['CharacterBag'..i..'Slot']
        local ic = _G['CharacterBag'..i..'SlotIconTexture']
        bu:SetNormalTexture''
        bu:SetPushedTexture''
        bu:SetBackdrop(BACKDROP)
        bu:SetBackdropColor(0, 0, 0)
        ic:SetTexCoord(.1, .9, .1, .9)
    end

        -- COLOUR
    local ColourBagBorders = function(self, slotID, texture, quality)
        local name = self:GetName()
        local questtext = _G[name..'IconQuestTexture']
        local search = _G[name].searchOverlay
        if texture then
                -- search
            if search:IsShown() then
                self.bo:SetBackdropBorderColor(r, g, b)
                -- quest
            elseif questtext and questtext:IsShown() then
                self.bo:SetBackdropBorderColor(248/255, 98/255, 86/255)
                -- uncommon+ quality
            elseif quality and quality >= 2 and BAG_ITEM_QUALITY_COLORS[quality] then
                local colour = BAG_ITEM_QUALITY_COLORS[quality]
                self.bo:SetBackdropBorderColor(colour.r, colour.g, colour.b)
            else
                self.bo:SetBackdropBorderColor(0, 0, 0, 0)
            end
        else
            self.bo:SetBackdropBorderColor(0, 0, 0, 0)
        end
    end

    local bag_ColourUpdate = function(frame)
        local name = frame:GetName()
        local id = frame:GetID()
        for i = 1, frame.size do
            local button = _G[name..'Item'..i]
            local itemID = GetContainerItemID(id, button:GetID())
            local texture, _, _, quality = GetContainerItemInfo(id, button:GetID())
            ColourBagBorders(button, itemID, texture, quality)
        end
    end

    hooksecurefunc('ContainerFrame_Update', bag_ColourUpdate)
    hooksecurefunc('ContainerFrame_UpdateSearchResults', bag_ColourUpdate)
