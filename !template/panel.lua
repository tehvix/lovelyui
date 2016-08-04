

	-- rewriting common xml templates
	--
	-- ui pnels

	local BACKDROP = {
		bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
		insets = {left = -3, right = -3, top = -3, bottom = -3}
	}
	local BACKDROP_BORDER = {
		bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
		edgeFile = [[Interface\Buttons\WHITE8x8]],
		tiled = false,
		edgeSize = -3,
		insets = {left = -3, right = -3, top = -3, bottom = -3}
	}

	local panel = function(self)
		local n = self:GetName()

		-- strip
		if _G[n..'PortraitFrame'] then	-- portrait panels
			for _, v in pairs({
				_G[n..'Bg'],             _G[n..'TitleBg'],
				_G[n..'Portrait'],       _G[n..'PortraitFrame'],
				_G[n..'TopRightCorner'], _G[n..'TopLeftCorner'], _G[n..'BotRightCorner'], _G[n..'BotLeftCorner'],
				_G[n..'TopBorder'],      _G[n..'BottomBorder'],  _G[n..'LeftBorder'],     _G[n..'RightBorder']
			}) do
				if v then v:Hide() end
			end
			_G[n..'TitleText']:ClearAllPoints()
			_G[n..'TitleText']:SetPoint('TOPLEFT', 12, -6)
			_G[n..'TopTileStreaks']:SetTexture''
			-- size
			if not n:find'Character' then self:SetSize(200, 315) end
		end

		local header = _G[n..'Header']
		if header then header:Hide() end

		-- x
		local x = _G[n..'CloseButton']
		if  x then
			x:ClearAllPoints()
			x:SetPoint('TOPRIGHT', self, 2, 2)
			x:SetNormalTexture''
			x.t = x:CreateFontString(nil, 'OVERLAY')
			x.t:SetPoint'CENTER'
			x.t:SetJustifyH'CENTER'
			x.t:SetFont([[Fonts\skurri.ttf]], 15)
			x.t:SetShadowOffset(1, -1.25)
			x.t:SetShadowColor(0, 0, 0, 1)
			x.t:SetTextColor(1, 0, 0)
			x.t:SetText'x'
		end

		-- skin
		if not n:find'Loot' then
			self:SetBackdrop(BACKDROP_BORDER)
			self:SetBackdropColor(0, 0, 0)
			self:SetBackdropBorderColor(0 ,0, 0)
		end
	end

	hooksecurefunc('ShowUIPanel', panel)

	--
