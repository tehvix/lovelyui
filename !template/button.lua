

	-- rewriting common xml templates
	--
	-- scrollframe

	local _, ns = ...

	local TEXTURE = [[Interface\AddOns\lovelyui\art\statusbar]]

	ns.button = function(self)
		for _, v in pairs({self.Left, self.Middle, self.Right}) do
			v:Hide()
		end
	end

	--
