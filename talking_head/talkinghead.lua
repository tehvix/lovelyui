

    local _, class = UnitClass'player'
    local colour   = RAID_CLASS_COLORS[class]

    local f = CreateFrame'Frame'
    f:RegisterEvent'ADDON_LOADED'
    f:SetScript('OnEvent', function(self, event, addon)
        if addon == 'Blizzard_TalkingHeadUI' then
            TalkingHeadFrame:SetSize(70, 70)
            TalkingHeadFrame:ClearAllPoints()
            TalkingHeadFrame:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOM', 146, 147)
            TalkingHeadFrame:SetBackdrop({bgFile = [[Interface\AddOns\lovelyui\minimap_cluster\hex2.tga]],
                            tiled = false,
                            insets = {left = -4, right = -4, top = -4, bottom = -4}})
            TalkingHeadFrame:SetBackdropColor(0, 0, 0)

            TalkingHeadFrame.NameFrame:SetSize(70, 24)
            TalkingHeadFrame.NameFrame:SetParent(TalkingHeadFrame.MainFrame.Model)
            TalkingHeadFrame.NameFrame:ClearAllPoints()
            TalkingHeadFrame.NameFrame:SetPoint('BOTTOMRIGHT', TalkingHeadFrame, -8, 8)
            TalkingHeadFrame.NameFrame:SetFrameLevel(TalkingHeadFrame.MainFrame.Model:GetFrameLevel() + 3)

            TalkingHeadFrame.NameFrame.Name:SetWidth(70)
            TalkingHeadFrame.NameFrame.Name:SetFont(STANDARD_TEXT_FONT, 9)
            TalkingHeadFrame.NameFrame.Name:SetTextColor(1, 1, 1)
            TalkingHeadFrame.NameFrame.Name:SetWordWrap(true)
            TalkingHeadFrame.NameFrame.Name:SetJustifyH'CENTER'
            TalkingHeadFrame.NameFrame.Name:ClearAllPoints()
            TalkingHeadFrame.NameFrame.Name:SetPoint('BOTTOM', TalkingHeadFrame.MainFrame.Model, 0, 4)

            for _, v in pairs({
                TalkingHeadFrame.TextFrame,
                TalkingHeadFrame.BackgroundFrame,
                TalkingHeadFrame.PortraitFrame.Portrait,
                TalkingHeadFrame.MainFrame.Sheen,
                TalkingHeadFrame.MainFrame.TextSheen,
                TalkingHeadFrame.MainFrame.Overlay,
                TalkingHeadFrame.MainFrame.Model.PortraitBg}) do
                v:Hide()
            end

            TalkingHeadFrame.MainFrame:SetSize(70, 70)

            TalkingHeadFrame.MainFrame.Model:SetSize(43, 43)
            TalkingHeadFrame.MainFrame.Model:ClearAllPoints()
            TalkingHeadFrame.MainFrame.Model:SetPoint('CENTER', TalkingHeadFrame)

            TalkingHeadFrame.MainFrame.Model.PortraitBg:SetSize(70, 70)
            TalkingHeadFrame.MainFrame.Model.PortraitBg:SetTexture[[Interface\AddOns\lovelyui\minimap_cluster\hex2.tga]]
            TalkingHeadFrame.MainFrame.Model.PortraitBg:SetVertexColor(colour.r*.2, colour.g*.2, colour.b*.2)
            TalkingHeadFrame.MainFrame.Model.PortraitBg:ClearAllPoints()
            TalkingHeadFrame.MainFrame.Model.PortraitBg:SetAllPoints(TalkingHeadFrame.MainFrame.Model)

            TalkingHeadFrame.MainFrame.Model.Shadow = TalkingHeadFrame.MainFrame.Model:CreateTexture(nil, 'OVERLAY')
            TalkingHeadFrame.MainFrame.Model.Shadow:SetSize(78, 78)
            TalkingHeadFrame.MainFrame.Model.Shadow:SetTexture[[Interface\AddOns\lovelyui\talking_head\hex-shadow.tga]]
            TalkingHeadFrame.MainFrame.Model.Shadow:SetVertexColor(colour.r*.2, colour.g*.2, colour.b*.2)
            TalkingHeadFrame.MainFrame.Model.Shadow:SetPoint('CENTER', TalkingHeadFrame.MainFrame.Model)

            TalkingHeadFrame.MainFrame.CloseButton:SetNormalTexture''
            TalkingHeadFrame.MainFrame.CloseButton:ClearAllPoints()
            TalkingHeadFrame.MainFrame.CloseButton:SetPoint('TOPRIGHT', Minimap, 10, 10)
            TalkingHeadFrame.MainFrame.CloseButton.t = TalkingHeadFrame.MainFrame.CloseButton:CreateFontString(nil, 'OVERLAY')
            TalkingHeadFrame.MainFrame.CloseButton.t:SetPoint'CENTER'
            TalkingHeadFrame.MainFrame.CloseButton.t:SetJustifyH'CENTER'
            TalkingHeadFrame.MainFrame.CloseButton.t:SetFont([[Fonts\skurri.ttf]], 15)
            TalkingHeadFrame.MainFrame.CloseButton.t:SetShadowOffset(1, -1.25)
            TalkingHeadFrame.MainFrame.CloseButton.t:SetShadowColor(0, 0, 0, 1)
            TalkingHeadFrame.MainFrame.CloseButton.t:SetTextColor(1, 0, 0)
            TalkingHeadFrame.MainFrame.CloseButton.t:SetText'x'

            f:UnregisterAllEvents()
        end
    end)

    --
