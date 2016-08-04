

	hooksecurefunc('LootFrame_Show', function(self)
		if GetCVar'lootUnderMouse' == '0' then
			self:Show()
			self:ClearAllPoints()
			if oUF_modPartyRaidUnitButton1:IsShown() and oUF_modBoss1:IsShown() then
				self:SetPoint('BOTTOM', UIParent, 288, 85)
			elseif
				oUF_modPartyRaidUnitButton1:IsShown() then
				self:SetPoint('BOTTOM', UIParent, 288, 120)
			else
				self:SetPoint('BOTTOM', UIParent, 288, 160)
			end
			self:GetCenter()
			self:Raise()
		end
	end)
