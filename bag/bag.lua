

							-- one-bag inventory
							-- based on Haleth's bagging method.
							-- obble

							-- to-do: full implementation of bankframe


	local ButtonSize = 24
	local ButtonSpacing = 3
	local buttons, bankbuttons = {}, {}
	local ItemsPerRow = 12
	local TEXTURE = [[Interface\AddOns\lovelyui\art\statusbar.tga]]
	local BACKDROP_BORDER = {
		bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
		edgeFile = [[Interface\Buttons\WHITE8x8]],
		tiled = false,
		edgeSize = -3,
		insets = {left = -3, right = -3, top = -3, bottom = -3}
	}

	local BACKDROP = {
		bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
		tiled = false,
		insets = {left = -3, right = -3, top = -3, bottom = -3}
	}


	local grab_slots = function()
		local numBags = 1
		for i = 1, NUM_BAG_FRAMES do
			local bagName = 'ContainerFrame'..i + 1
			if _G[bagName]:IsShown() and not _G[bagName..'BackgroundTop']:GetTexture():find'Bank' then
				numBags = numBags + 1
			end
		end
		return numBags
	end

	local bagmaxSpace = function()
		local ct = 0
		for bag = 0, NUM_BAG_SLOTS do
			for slot = 1, GetContainerNumSlots(bag) do
				ct = ct + 1
			end
		end
		return ct
	end

	local bagSpace = function()
		local ct = 0
		for bag = 0, NUM_BAG_SLOTS do
			for slot = 1, GetContainerNumSlots(bag) do
				local  link = GetContainerItemLink(bag, slot)
				if not link then ct = ct + 1 end
			end
		end
		return ct
	end

	local bankmaxSpace = function()
		local ct = 0
		for bag = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
			for slot = 1, GetContainerNumSlots(bag) do
				ct = ct + 1
			end
		end
		return ct
	end

	local bankSpace = function()
		local ct = 0
		for bag = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
			for slot = 1, GetContainerNumSlots(bag) do
				local  link = GetContainerItemLink(bag, slot)
				if not link then ct = ct + 1 end
			end
		end
		return ct
	end


		-- HIDE OLD ART
	local bagHide = function(bagName)
		local bag = _G[bagName]
		if not bag.stripped then
			for i = 1, 7 do select(i, bag:GetRegions()):SetAlpha(0) end
			bag:EnableMouse(false)
			bag.ClickableTitleFrame:EnableMouse(false)
			_G[bagName..'CloseButton']:Hide()
			_G[bagName..'PortraitButton']:EnableMouse(false)
			bag.stripped = true
		end
	end

	local bankArtToggle = function(isReagentBank, parent)
		BankFrameMoneyFrameInset:Hide()
		BankFrameMoneyFrameBorder:Hide()

		if isReagentBank then
			BankFramePurchaseInfo:Show()
			BankFrame:EnableMouse(true)
			BankFrameCloseButton:Show()
			BankFrame:EnableDrawLayer'BACKGROUND'
			BankFrame:EnableDrawLayer'BORDER'
			BankFrame:EnableDrawLayer'OVERLAY'
			BankSlotsFrame:EnableDrawLayer'BORDER'
			BankPortraitTexture:Show()
		else
			BankFramePurchaseInfo:Hide()
			BankFrame:EnableMouse(false)
			BankFrameCloseButton:Hide()
			BankFrame:DisableDrawLayer'BACKGROUND'
			BankFrame:DisableDrawLayer'BORDER'
			BankFrame:DisableDrawLayer'OVERLAY'
			BankSlotsFrame:DisableDrawLayer'BORDER'
			BankPortraitTexture:Hide()
		end

		if  BankFrame:IsShown() then
			BankFrameTab1:SetParent(parent)
			BankFrameTab1:DisableDrawLayer'BACKGROUND' BankFrameTab2:DisableDrawLayer'BACKGROUND'
			BankFrameTab1:SetScale(.8) BankFrameTab2:SetScale(.8)
			BankFrameTab1:ClearAllPoints()
			BankFrameTab1:SetPoint('TOPLEFT', parent, 'BOTTOMLEFT', 11, 2)

		end
	end

		-- REPARENT/MOVE BUTTONS
	local bu, con, bag, col, row
	local MoveButtons = function(table, frame)
		local columns = ceil(sqrt(#table))
		col, row = 0, 0

		for i = 1, #table do
			bu = table[i]
			-- bu:SetParent(frame)
			bu:SetSize(ButtonSize, ButtonSize)
			bu:ClearAllPoints()
			bu:SetPoint('TOPLEFT', frame, col*(ButtonSize + ButtonSpacing), -1*row*(ButtonSize + ButtonSpacing) - 55)

				-- bg art
			if not bu.bg then
				bu.bg = bu:CreateTexture(nil, 'BACKGROUND')
				bu.bg:SetTexture[[Interface\PaperDoll\UI-Backpack-EmptySlot]]
				bu.bg:SetTexCoord(.1, .9, .1, .9)
				bu.bg:SetAlpha(.5)
				bu.bg:SetAllPoints()
			end

			if col > (columns - 2) then
				col = 0
				row = row + 1
			else
				col = col + 1
			end
		end

		frame:SetHeight((row + (col == 0 and 0 or 1))*(ButtonSize + ButtonSpacing) + 91)
		frame:SetWidth(columns*ButtonSize + ButtonSpacing*(columns - 1))
		col, row = 0, 0
	end


		-- CONTAINER
	local bagContainer = CreateFrame('Frame', nil , UIParent)
	bagContainer:SetPoint('BOTTOMRIGHT', _G['modbar'], 'TOPRIGHT', -40, 40)
	bagContainer:SetBackdrop(BACKDROP_BORDER)
	bagContainer:SetBackdropColor(0, 0, 0)
	bagContainer:SetBackdropBorderColor(0, 0, 0)
	bagContainer:Hide()

	local bankContainer = CreateFrame('Button', nil, UIParent)
	bankContainer:SetPoint('BOTTOMRIGHT', bagContainer, 'BOTTOMLEFT', -20, 0)
	bankContainer:SetBackdrop(BACKDROP_BORDER)
	bankContainer:SetBackdropColor(0, 0, 0)
	bankContainer:SetBackdropBorderColor(0, 0, 0)
	bankContainer:Hide()

	local Container = CreateFrame('Frame', 'BagForM', bagContainer)
	Container:SetPoint'BOTTOMRIGHT'

	local space = CreateFrame('StatusBar', nil, bagContainer)
	space:SetStatusBarTexture(TEXTURE)
	space:SetHeight(5)
	space:SetPoint('TOPLEFT',  bagContainer, 0, -47)
	space:SetPoint('TOPRIGHT', bagContainer, 0, -47)
	space:SetMinMaxValues(0, 100) space:SetValue(100)
	space:SetStatusBarTexture(97/255, 208/255, 30/255)
	space:SetBackdrop(BACKDROP)
	space:SetBackdropColor(0, 0, 0)

	local bankspace = CreateFrame('StatusBar', nil, bankContainer)
	bankspace:SetStatusBarTexture(TEXTURE)
	bankspace:SetHeight(5)
	bankspace:SetPoint('TOPLEFT',  bankContainer, 0, -47)
	bankspace:SetPoint('TOPRIGHT', bankContainer, 0, -47)
	bankspace:SetMinMaxValues(0, 100) bankspace:SetValue(100)
	bankspace:SetStatusBarTexture(245/255, 172/255, 144/255)
	bankspace:SetBackdrop(BACKDROP)
	bankspace:SetBackdropColor(0, 0, 0)

	local name = bagContainer:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	name:SetFont(STANDARD_TEXT_FONT, 12)
	name:SetText'Inventory'
	name:SetPoint('TOPLEFT', 5, -5)

	local bname = bankContainer:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	bname:SetFont(STANDARD_TEXT_FONT, 12)
	bname:SetText'Bank'
	bname:SetPoint('TOPLEFT', 5, -5)


		-- SET-UP BAG
	local ReAnchor = function()
		table.wipe(buttons)
		for f = 1, grab_slots() do
			con = 'ContainerFrame'..f
			bagHide(con)
			for i = GetContainerNumSlots(_G[con]:GetID()), 1, -1 do
				bu = _G[con..'Item'..i]
				tinsert(buttons, bu)
			end
		end
		MoveButtons(buttons, bagContainer)
		bagContainer:Show()
		Container:SetSize(bagContainer:GetWidth(), bagContainer:GetHeight())
	end


		-- SET-UP BANK
	local cachedBankWidth, cachedBankHeight
	local ReanchorBank = function(noMoving)
		for _, button in pairs(bankbuttons) do button:Hide() end

		table.wipe(bankbuttons)

		for i = 1, 28 do
			bu = _G['BankFrameItem'..i]
			tinsert(bankbuttons, bu)
			bu:Show()
		end

		local bagNameCount = 0
		for f = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
			bagNameCount = bagNameCount + 1
			con = 'ContainerFrame'..grab_slots() + bagNameCount
			bagHide(con)
			-- _G[con]:SetScale(1) -- a fix
			for i = GetContainerNumSlots(f), 1, -1  do
				bu = _G[con..'Item'..i]
				tinsert(bankbuttons, bu)
				bu:Show()
			end
		end

		if not noMoving then
			MoveButtons(bankbuttons, bankContainer)
			cachedBankWidth = bankContainer:GetWidth()
			cachedBankHeight = bankContainer:GetHeight()
		else
			bankContainer:SetWidth(cachedBankWidth)
			bankContainer:SetHeight(cachedBankHeight)
		end

		local bagHeight, bagWidth = bagContainer:GetHeight(), bagContainer:GetWidth()
		local bankHeight, bankWidth = bankContainer:GetHeight(), bankContainer:GetWidth()

		local height = (bankHeight > bagHeight) and bankHeight or bagHeight
		Container:SetSize(bagWidth + bankWidth + 20, height)

		if bankWidth < 200 then
			for i = 1, 7 do BankSlotsFrame['Bag'..i]:SetScale(.85) end
		end

		bankContainer:Show()
	end


		-- CA$H
	local money = ContainerFrame1MoneyFrame
	money:SetParent(bagContainer)
	money:ClearAllPoints()
	money:SetPoint('TOPLEFT', bagContainer, 6, -25)
	money:SetFrameStrata'HIGH'
	money:SetFrameLevel(5)

	for _, v in pairs({
		ContainerFrame1MoneyFrameCopperButtonText,
		ContainerFrame1MoneyFrameSilverButtonText,
		ContainerFrame1MoneyFrameGoldButtonText}) do
		v:SetFont(STANDARD_TEXT_FONT, 9)
		v:SetShadowOffset(1, -1)
	    v:SetShadowColor(0, 0, 0, 1)
	end

	BankFrameMoneyFrame:Hide()


		-- TOKENS
	BackpackTokenFrame:GetRegions():Hide()
	BackpackTokenFrameToken1:ClearAllPoints()
	BackpackTokenFrameToken1:SetPoint('BOTTOMLEFT', Container, 15, 8)
	for i = 1, MAX_WATCHED_TOKENS do
		_G['BackpackTokenFrameToken'..i]:SetParent(bagContainer)
		_G['BackpackTokenFrameToken'..i]:SetFrameStrata'HIGH'
	end


		-- SORT & SEARCH
	local search_Move = function(frame)
		frame:ClearAllPoints()
		frame:SetPoint('TOPRIGHT', BagItemAutoSortButton, 'TOPLEFT', -3, 0)
		frame:SetPoint('BOTTOMLEFT', money, 'BOTTOMRIGHT', 6, 0)
	end

	hooksecurefunc('ContainerFrame_Update', function()
		local sort = BagItemAutoSortButton
		local search = BagItemSearchBox
		sort:SetSize(ButtonSize - 1, ButtonSize - 1)
		sort:SetParent(bagContainer)
		sort:ClearAllPoints()
		sort:SetPoint('TOPRIGHT', bagContainer, 0, -20)
		search:SetHeight(80)
		search:SetParent(bagContainer)
		search_Move(search)
	end)

	search_Move(BagItemSearchBox)
	BankItemSearchBox:Hide()
	BankItemAutoSortButton:EnableMouse(false)
	BankItemAutoSortButton:SetAlpha(0)

		-- OPEN/CLOSE
	local CloseBags = function()
		bankContainer:Hide()
		bagContainer:Hide()
		bankArtToggle(false, BankFrame)
		for i = 0, 11 do CloseBag(i) end
	end

	local CloseBags2 = function()
		bankContainer:Hide()
		bagContainer:Hide()
		CloseBankFrame()
	end

	local OpenBags = function()
		bankArtToggle(false, BankFrame)
		for i = 0, 4 do OpenBag(i) end
	end

	local ToggleBags = function()
		if IsBagOpen(0) then
			CloseBankFrame()
			CloseBags()
		else OpenBags() end
	end

	for i = 1, 5 do
		local bag = _G['ContainerFrame'..i]
		hooksecurefunc(bag, 'Show', ReAnchor)
		hooksecurefunc(bag, 'Hide', CloseBags2)
	end

	hooksecurefunc(BankFrame, 'Show', function()
		for i = 0, 11 do OpenBag(i) end
		ReanchorBank()
		bankArtToggle(false, Container)
		search_Move(BagItemSearchBox)
	end)

	hooksecurefunc(BankFrame, 'Hide', function() CloseBags() bankArtToggle(false, BankFrame) end)


		-- REMOVE BAG SLOT TOGGLE FUNCTION
	BagSlotButton_OnClick = function(self)
		local id = self:GetID()
		local hadItem = PutItemInBag(id)
		return
	end

	BankFrameItemButtonBag_OnClick = function(self, button)
		local id = self:GetInventorySlot()
		local hadItem = PutItemInBag(id)
		if not hadItem then return end
	end

	local HideBank = function()
		for i = 5, 11 do CloseBag(i) end
		bankContainer:Hide()
		search_Move(BagItemSearchBox)
		ReAnchor()
	end

		-- HIDE/SHOW BANK BAG W/ REAGENTBANK
	ReagentBankFrame:HookScript('OnShow', function()
		HideBank()
		bankArtToggle(true, BankFrame)
	end)

	ReagentBankFrame:HookScript('OnHide', function()
		if BankFrame:IsShown() then
			for i = 0, 11 do OpenBag(i) end
			ReanchorBank()
			bankArtToggle(false, Container)
		end
	end)

	-- BAG SLOTS
	local bagSparkles = function(self, isEnter)
		if self.isMainBag then
			for j = 1, GetContainerNumSlots(0) do
				local bu = _G['ContainerFrame1Item'..j]

				if not bu.sparkle then
					bu.sparkle = CreateFrame('Button', 'MainButtonSparkle'..j, bu, 'AutoCastShineTemplate')
					bu.sparkle:RegisterForClicks'NONE'
					bu.sparkle:SetAllPoints(bu)
					bu.sparkle:Hide()
				end

				if isEnter then
					bu.sparkle:SetFrameStrata'HIGH'
					bu.sparkle:Show()
					AutoCastShine_AutoCastStart(bu.sparkle, 0, 1, 0)
				else
					bu.sparkle:SetFrameStrata'LOW'
					bu.sparkle:Hide()
					AutoCastShine_AutoCastStop(bu.sparkle)
				end
			end
		else
			local id = self:GetID() - CharacterBag0Slot:GetID() + 1
			for i = 1, NUM_CONTAINER_FRAMES do
				local frame = _G['ContainerFrame'..i]
				if frame:GetID() == id then
					for j = 1, GetContainerNumSlots(id) do
						local bu = _G['ContainerFrame'..i..'Item'..j]

						if not bu.sparkle then
							bu.sparkle = CreateFrame('Button', 'Button'..i..'Sparkle'..j, bu, 'AutoCastShineTemplate')
							bu.sparkle:RegisterForClicks'NONE'
							bu.sparkle:SetAllPoints(bu)
							bu.sparkle:Hide()
						end

						if isEnter then
							bu.sparkle:SetFrameStrata'HIGH'
							bu.sparkle:Show()
							AutoCastShine_AutoCastStart(bu.sparkle, .5*(i - 1), 2/(i - 1), .5/(i - 1)) -- green > red
						else
							bu.sparkle:SetFrameStrata'LOW'
							bu.sparkle:Hide()
							AutoCastShine_AutoCastStop(bu.sparkle)
						end
					end
				end
			end
		end
	end

	MainMenuBarBackpackButton:HookScript('OnEnter', function(self)
		if bagContainer:IsShown() then
			self.isMainBag = true
			bagSparkles(self, true)
		end
	end)

	MainMenuBarBackpackButton:HookScript('OnLeave', function(self)
		bagSparkles(self, false)
	end)

	for i = 0, 3 do
		local bag = _G['CharacterBag'..i..'Slot']
		local ic = _G['CharacterBag'..i..'SlotIconTexture']

		bag:UnregisterEvent'ITEM_PUSH'
		bag:SetCheckedTexture''
		bag:SetHighlightTexture''
		bag:SetParent(Container)
		bag:SetSize(ButtonSize, ButtonSize)
		bag:ClearAllPoints()

		if i == 0 then
			bag:SetPoint('BOTTOMRIGHT', bagContainer, 0, 5)
		else
			bag:SetPoint('RIGHT', _G['CharacterBag'..(i - 1)..'Slot'], 'LEFT', -3, 0)
		end

		bag.IconBorder:SetAlpha(0)
		ic:SetTexCoord(.1, .9, .1, .9)

		bag:SetScript('OnEnter', function(self)
			bagSparkles(self, true)
		end)

		bag:SetScript('OnLeave', function(self)
			bagSparkles(self, false)
		end)

		bag:SetScript('OnClick', nil)
		--bag:HookScript('OnReceiveDrag', function() CloseBags() ClearCursor() end)
	end


		-- BANK SLOTS
	local function bankSparkle(self, isEnter)
		local id = self:GetID() + NUM_BAG_SLOTS
		for i = 1, NUM_CONTAINER_FRAMES do
			local frame = _G['ContainerFrame'..i]
			if frame:GetID() == id then
				for j = 1, GetContainerNumSlots(frame:GetID()) do
					local bu = _G['ContainerFrame'..i..'Item'..j]

					if not bu.sparkle then
						bu.sparkle = CreateFrame('Button', 'Button'..i..'Sparkle'..j, bu, 'SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerEnterLeaveTemplate, AutoCastShineTemplate')
						bu.sparkle:RegisterForClicks'NONE'
						bu.sparkle:SetAllPoints(bu)
						bu.sparkle:Hide()
					end

					if isEnter then
						bu.sparkle:SetFrameStrata'HIGH'
						bu.sparkle:Show()
						AutoCastShine_AutoCastStart(bu.sparkle, .25*i, .2/i, .2/i)
					else
						bu.sparkle:SetFrameStrata'LOW'
						bu.sparkle:Hide()
						AutoCastShine_AutoCastStop(bu.sparkle)
					end
				end
			end
		end
	end

	for i = 1, 7 do
		local bag = BankSlotsFrame['Bag'..i]
		local _, highlight = bag:GetChildren()
		local bagborder = bag.IconBorder

		bagborder:SetAlpha(0)
		highlight:Hide()
		bag:UnregisterEvent'ITEM_PUSH'
		bag:SetHighlightTexture''
		bag:SetParent(bankContainer)
		bag:SetSize(ButtonSize, ButtonSize)
		bag:ClearAllPoints()

		bankContainer:HookScript('OnShow', function() bag:SetParent(Container) end)
		bankContainer:HookScript('OnHide', function() bag:SetParent(bankContainer) end)

		if i == 1 then
			bag:SetPoint('BOTTOMRIGHT', bankContainer, 0, 5)
		else
			bag:SetPoint('RIGHT', BankSlotsFrame['Bag'..(i - 1)], 'LEFT', -3, 0)
		end

		bag:SetScript('OnEnter', function(self)
			bankSparkle(self, true)
		end)

		bag:SetScript('OnLeave', function(self)
			bankSparkle(self, false)
		end)
	end


		-- X
	local close = CreateFrame('Button', nil, bagContainer)
	close:SetSize(ButtonSize - 5, ButtonSize - 5)
	close:SetPoint('TOPRIGHT', bagContainer)
	close:SetScript('OnClick', ToggleBags)

	close.t = close:CreateFontString(nil, 'OVERLAY')
	close.t:SetFont([[Fonts\skurri.ttf]], 15)
	close.t:SetText'x'
	close.t:SetTextColor(1, 0, 0)
	close.t:SetPoint('CENTER', 1, 1)

	local close_bank = CreateFrame('Button', nil, bankContainer)
	close_bank:SetSize(ButtonSize - 5, ButtonSize - 5)
	close_bank:SetPoint('TOPRIGHT', bankContainer)
	close_bank:SetScript('OnClick', function() HideBank() CloseBankFrame() bankArtToggle(false, BankFrame) end)

	close_bank.t = close_bank:CreateFontString(nil, 'OVERLAY')
	close_bank.t:SetFont([[Fonts\skurri.ttf]], 15)
	close_bank.t:SetText'x'
	close_bank.t:SetTextColor(1, 0, 0)
	close_bank.t:SetPoint('CENTER', 1, 1)


		-- REDIRECTS
	function UpdateContainerFrameAnchors() end
	ToggleBackpack = ToggleBags
	ToggleBag = ToggleBags
	OpenAllBags = OpenBags
	OpenBackpack = OpenBags
	CloseAllBags = CloseBags

		-- SORT BAGS TOP > BOTTOM!
	SetSortBagsRightToLeft(true)
	SetInsertItemsLeftToRight(false)

	local f = CreateFrame'Frame'
	f:RegisterEvent'PLAYER_ENTERING_WORLD'
    f:RegisterEvent'UNIT_INVENTORY_CHANGED'
    f:RegisterEvent'BAG_UPDATE'
    f:RegisterEvent'BANKFRAME_OPENED'
	f:SetScript('OnEvent', function()
		space:SetMinMaxValues(0, bagmaxSpace())
		space:SetValue(bagSpace())
		local v, max = bankSpace(), bankmaxSpace()
		bankspace:SetMinMaxValues(0, max > 1 and max or 1)
		bankspace:SetValue(max > 1 and v or 1)
	end)
