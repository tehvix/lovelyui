

    local r, g, b = 103/255, 103/255, 103/255

    local BACKDROP = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        tiled = false,
        insets = {left = -3, right = -3, top = -3, bottom = -3}
    }
    local BORDER = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        edgeFile = [[Interface\Buttons\WHITE8x8]],
        edgeSize = 1,
    }

        -- REAGENT BANK
    local function SkinReagentButtons()
        if IsReagentBankUnlocked() then
            for i = 1, 98 do
                local bu = _G['ReagentBankFrameItem'..i]
                local co = _G['ReagentBankFrameItem'..i..'Count']
                if bu and not bu.skinned then
                    local border = bu.IconBorder
                    co:SetDrawLayer('OVERLAY', 7)
                    co:SetJustifyH'CENTER'
                    co:ClearAllPoints()
                    co:SetPoint('CENTER', bu, 'BOTTOM')
                    co:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
                    border:SetAlpha(0)
                    bu.skinned = true
                    BankFrameItemButton_Update(bu)
                end
            end
        end
    end


    local SkinBankButtons = CreateFrame'Frame'
    SkinBankButtons:RegisterEvent'PLAYER_ENTERING_WORLD'
    SkinBankButtons:RegisterEvent'UNIT_INVENTORY_CHANGED'
    SkinBankButtons:RegisterEvent'BAG_UPDATE'
    SkinBankButtons:RegisterEvent'ITEM_LOCK_CHANGED'
    SkinBankButtons:RegisterEvent'BAG_CLOSED'
    SkinBankButtons:RegisterEvent'PLAYERREAGENTBANKSLOTS_CHANGED'
    SkinBankButtons:RegisterEvent'REAGENTBANK_PURCHASED'
    SkinBankButtons:RegisterEvent'REAGENTBANK_UPDATE'
    SkinBankButtons:RegisterEvent'BANKFRAME_OPENED'
    SkinBankButtons:SetScript('OnEvent', function(self, event, ...)
            -- bank buttons
        for i = 1, 28 do
            local f  = 'BankFrameItem'..i
            local bu = _G[f]
            local ic = _G[f..'IconTexture']
            local co = _G[f..'Count']
            local border = bu.IconBorder
            if bu and not bu.skinned then
                bu:SetNormalTexture''
                bu:SetPushedTexture''
                bu:SetHighlightTexture''

                bu:SetBackdrop(BACKDROP)
                bu:SetBackdropColor(0, 0, 0)

                bu.bo = CreateFrame('Frame', nil, bu)
                bu.bo:SetAllPoints(ic)
                bu.bo:SetFrameLevel(5)
                bu.bo:SetBackdrop(BORDER)
                bu.bo:SetBackdropColor(0, 0, 0, 0)

                ic:SetTexCoord(.1, .9, .1, .9)

                border:SetAlpha(0)

                co:SetDrawLayer('OVERLAY', 7)
                co:SetJustifyH'CENTER'
                co:ClearAllPoints()
                co:SetPoint('CENTER', bu, 'BOTTOM')
                bu.skinned = true
            end
        end


        for i = 1, 7 do
            BankSlotsFrame['Bag'..i]:SetNormalTexture''
        end

            -- skin reagent bank when it's unlocked
        if event == 'REAGENTBANK_PURCHASED' or event == 'REAGENTBANK_UPDATE' then
            SkinReagentButtons()
        end
    end)

    for i = 1, 7 do
        local bu = BankSlotsFrame['Bag'..i]
        local ic = BankSlotsFrame['Bag'..i].icon
        bu:SetNormalTexture''
        bu:SetPushedTexture''
        bu:SetBackdrop(BACKDROP)
        bu:SetBackdropColor(0, 0, 0)
        ic:SetTexCoord(.1, .9, .1, .9)
    end

        -- skin reagent bank
    hooksecurefunc('ReagentBankFrameItemButton_OnLoad', SkinReagentButtons)

        -- BORDER COLOURING
    local function ColourBagBorders(self)
            -- don't try and colour reagent bank borders if they dont exist yet
        if ReagentBankFrame.UnlockInfo:IsShown() then return end
        local q = self['IconQuestTexture']
            -- quest
        if q:IsShown() then
            self.bo:SetBackdropBorderColor(248/255, 98/255, 86/255)
            -- uncommon+ quality
        elseif self.quality and self.quality >= 2 and BAG_ITEM_QUALITY_COLORS[self.quality] then
            local colour = BAG_ITEM_QUALITY_COLORS[self.quality]
            self.bo:SetBackdropBorderColor(colour.r, colour.g, colour.b)
        else
            self.bo:SetBackdropBorderColor(0, 0, 0, 0)
        end
    end

        -- COLOUR
    hooksecurefunc('BankFrameItemButton_Update', function(self)
        local bankid = 	self:GetID()
        local container = self:GetParent():GetID()
        if container == 0 then return end -- stop colouring bags
        local texture, _, _, _, _, _, itemLink = GetContainerItemInfo(container, bankid)
        local isQuestItem, questId = GetContainerItemQuestInfo(container, bankid)
        self.type = nil
        self.ilink = itemLink
        self.quality = nil

        if self.ilink then
            self.name, _, self.quality, _, _, self.type = GetItemInfo(self.ilink)
        end

        if isQuestItem or questId then
            self.type = QUEST_ITEM_STRING
        end

        ColourBagBorders(self)
    end)
