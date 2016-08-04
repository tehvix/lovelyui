

	-- rewriting common xml templates
	--
	-- scrollframe

	local TEXTURE = [[Interface\AddOns\lovelyui\art\statusbar]]

	local exceptions = {
		'GossipGreetingScrollFrame',
		'GossipGreetingScrollChildFrame',
	}

	local scrollframe = function(self)
		local n = self:GetName()
		self:SetSize(165, 217)
		for _, v in pairs({self:GetRegions()}) do
			if v:GetObjectType() == 'Texture' then v:Hide() end
		end
	end

	local scrollbar = function(self)
		local frame = self.scrollBar or self.ScrollBar
		if frame then
			if not frame.lovely then
				local n = frame:GetName()

				for _, v in pairs({_G[n..'Track'], _G[n..'BG'], _G[n..'Top'], _G[n..'Middle'], _G[n..'Bottom']}) do
					if v then v:Hide() end
				end

				local up = _G[n..'ScrollUpButton']
				local dn = _G[n..'ScrollDownButton']
				for _, v in pairs({up, dn}) do
					v:SetDisabledTexture'' v:SetNormalTexture''
					v:SetDisabledTexture'' v:SetNormalTexture''
					v.t = v:CreateFontString(nil, 'OVERLAY')
					v.t:SetPoint'CENTER'
					v.t:SetJustifyH'CENTER'
					v.t:SetFont(STANDARD_TEXT_FONT, 12)
					v.t:SetShadowOffset(1, -1.25)
					v.t:SetShadowColor(0, 0, 0, 1)
					v.t:SetTextColor(1, 1, 1)
				end
				up.t:SetText'Up'
				dn.t:SetText'Dn'

				local bu = frame.thumbTexture or _G[n..'ThumbTexture']
				bu:SetAlpha(0) bu:SetSize(2, 17)

				frame.sb = CreateFrame('Statusbar', nil, frame)
				frame.sb:SetPoint('TOPLEFT', 10, -4)
				frame.sb:SetPoint('BOTTOMRIGHT', bu, 0, 4)
				frame.sb:SetMinMaxValues(0, 1) frame.sb:SetValue(1)
				frame.sb:SetOrientation'VERTICAL'
				frame.sb:SetStatusBarTexture(TEXTURE)
				frame.sb:SetStatusBarColor(1, 1, 1)

				frame.lovely = true
			end
		end
	end

	for _, v in pairs(exceptions) do
		_G[v]:HookScript('OnShow', function(self)
			local name = self:GetName()
			if name:find'ScrollFrame' then scrollframe(self) end
			if name:find'ScrollChildFrame' then scrollframe(self) end
			if self.ScrollBar then scrollbar(self) end
		end)
	end

	hooksecurefunc('ScrollFrame_OnScrollRangeChanged', scrollbar)
	hooksecurefunc('HybridScrollFrame_Update', scrollbar)

	--
