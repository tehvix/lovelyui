
	local _, ns = ...

	hooksecurefunc('GameMenuFrame_UpdateVisibleButtons', function(self)
		local num = self:GetNumChildren()
		for i = 1, num do
			local f = select(i, self:GetChildren())
			local n = f:GetName()
			if n:find'Button' then
				ns.button(f)
			end
		end
	end)

	--
