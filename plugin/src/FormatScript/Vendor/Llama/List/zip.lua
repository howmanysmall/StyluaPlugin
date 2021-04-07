local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert
local Typer_Array = Typer.Array

local function zip(...)
	local new = {}
	local argCount = select("#", ...)

	if argCount <= 0 then
		return new
	end

	local firstList = Debug_Assert(Typer_Array(select(1, ...)))
	local minLen = #firstList

	for i = 2, argCount do
		local list = Debug_Assert(Typer_Array(select(i, ...)))
		local len = #list

		if len < minLen then
			minLen = len
		end
	end

	for i = 1, minLen do
		new[i] = {}

		for j = 1, argCount do
			new[i][j] = select(j, ...)[i]
		end
	end

	return new
end

return zip
