

	local sub = CreateFrame('Frame', nil, SubZoneTextFrame)
	sub:ClearAllPoints()
	sub:SetPoint('TOP', SubZoneTextString, 0, 6)
	sub:SetPoint('BOTTOM', SubZoneTextString, 0 ,-6)
	sub:SetHeight(30)

	hooksecurefunc('SetZoneText', function(show)
		for _, v in pairs({ZoneTextFrame, PVPInfoTextString, PVPArenaTextString, PVPInfoTextString}) do
			v:Hide()
		end

		sub:SetWidth(SubZoneTextString:GetStringWidth() + 16)

		SubZoneTextFrame:ClearAllPoints()
		SubZoneTextFrame:SetParent(UIParent)

		SubZoneTextString:SetJustifyH'LEFT'

		if not show then
			PVPInfoTextString:SetText''
			SubZoneTextFrame:SetPoint('CENTER', UIParent, 10, -10)
		end
		if  PVPInfoTextString:GetText() == '' then
			SubZoneTextFrame:SetPoint('CENTER', UIParent, 10, -10)
		else
			SubZoneTextString:SetPoint('TOPLEFT', 'PVPInfoTextString', 'BOTTOMLEFT', 0, -2)
			PVPInfoTextString:ClearAllPoints()
			PVPInfoTextString:SetPoint('CENTER', UIParent, 10, -10)
		end
	end)

	--
