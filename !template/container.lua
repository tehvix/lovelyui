

	-- fluid container

	local _, ns = ...

	local BACKDROP = {
		bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
		insets = {left = -3, right = -3, top = -3, bottom = -3}
	}

	local f = CreateFrame('Frame', 'lovelyui_container', UIParent)
	f:SetSize(300, 20)
	f:SetPoint('BOTTOM', 0, 155)

	--
