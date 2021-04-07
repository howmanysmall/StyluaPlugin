local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert
local Typer_Table = Typer.Table

local function intersection(...)
	local new = {}
	local argCount = select("#", ...)
	local firstSet = Debug_Assert(Typer_Table(select(1, ...)))

	for key in next, firstSet do
		local intersects = true

		for i = 2, argCount do
			local set = Debug_Assert(Typer_Table(select(i, ...)))
			if set[key] == nil then
				intersects = false
				break
			end
		end

		if intersects then
			new[key] = true
		end
	end

	return new
end

return intersection
