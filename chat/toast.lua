

    BNToastFrame:SetClampedToScreen(true)
    BNToastFrame:HookScript('OnShow', function(self)
    BNToastFrame:ClearAllPoints()
    BNToastFrame:SetPoint('BOTTOMRIGHT', ChatFrame1EditBox, 'BOTTOMLEFT', -20, 15)
    BNToastFrame:SetSize(70, 55)
    BNToastFrame:SetBackdrop{
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        tiled = false,
        insets = {left = -3, right = -3, top = -3, bottom = -3}
    }
    BNToastFrame:SetBackdropColor(0, 0, 0, 0.8)
    BNToastFrame:SetBackdropBorderColor(0, 0, 0, 1)

    --local ft, fs, ff = BNToastFrameTopLine:GetFont()
    BNToastFrameTopLine:SetFont(STANDARD_TEXT_FONT, 11)
    BNToastFrameTopLine:SetShadowOffset(.7, -.7)
    BNToastFrameTopLine:SetShadowColor(0, 0, 0, 1)
    BNToastFrameTopLine:SetJustifyH'CENTER'
    BNToastFrameTopLine:ClearAllPoints()
    BNToastFrameTopLine:SetPoint('TOP', 0, -14)

    BNToastFrameIconTexture:SetSize(22, 22)
    BNToastFrameIconTexture:ClearAllPoints()
    BNToastFrameIconTexture:SetPoint('TOPLEFT', -1, 1)

    BNToastFrameMiddleLine:SetFont(STANDARD_TEXT_FONT, 8)
    BNToastFrameMiddleLine:SetShadowOffset(.7, -.7)
    BNToastFrameMiddleLine:SetShadowColor(0, 0, 0, 1)
    BNToastFrameMiddleLine:ClearAllPoints()
    BNToastFrameMiddleLine:SetPoint('TOPLEFT', 2, -32)
    BNToastFrameMiddleLine:SetWidth(68)

    BNToastFrameBottomLine:SetFont(STANDARD_TEXT_FONT, 8)
    BNToastFrameBottomLine:SetShadowOffset(.7, -.7)
    BNToastFrameBottomLine:SetShadowColor(0, 0, 0, 1)
    BNToastFrameBottomLine:ClearAllPoints()
    BNToastFrameBottomLine:SetPoint('TOPLEFT', 2, -42)

    BNToastFrameDoubleLine:SetFont(STANDARD_TEXT_FONT, 8)
    BNToastFrameDoubleLine:SetShadowOffset(.7, -.7)
    BNToastFrameDoubleLine:SetShadowColor(0, 0, 0, 1)

    BNToastFrameCloseButton:SetNormalTexture''
    BNToastFrameCloseButton:SetPushedTexture''
    BNToastFrameCloseButton:SetHighlightTexture''

    BNToastFrameCloseButton.t = BNToastFrameCloseButton:CreateFontString(nil, 'OVERLAY')
    BNToastFrameCloseButton.t:SetFont(STANDARD_TEXT_FONT, 10)
    BNToastFrameCloseButton.t:SetShadowOffset(.7, -.7)
    BNToastFrameCloseButton.t:SetShadowColor(0, 0, 0,1)
    BNToastFrameCloseButton.t:SetPoint'CENTER'
    BNToastFrameCloseButton.t:SetText'x'
    BNToastFrameCloseButton.t:SetTextColor(230/255, 173/255, 0)
    BNToastFrameCloseButton:SetPoint('TOPRIGHT', 2, 2)

    BNToastFrameCloseButton:SetScript("OnEnter", function(self) BNToastFrameCloseButton.t:SetTextColor(255/255, 0, 0) end)
    BNToastFrameCloseButton:SetScript("OnLeave", function(self) BNToastFrameCloseButton.t:SetTextColor(230/255, 173/255, 0) end)
end)

SlashCmdList['TOAST'] = function()
	BNToastFrame:Show()
    BNToastFrameTopLine:SetText'LYN'
    BNToastFrameMiddleLine:SetText'has gone offline'
    BNToastFrameBottomLine:SetText':333'
end
SLASH_TOAST1 = '/to'
