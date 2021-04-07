local Debug = require(script.Parent.Parent.Parent.Debug)
local None = require(script.Parent.Parent.None)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert
local Typer_Array = Typer.Array

local function zipAll(...)
	local new = {}
	local argCount = select("#", ...)
	local maxLen = 0

	for i = 1, argCount do
		local list = Debug_Assert(Typer_Array(select(i, ...)))
		local len = #list

		if len > maxLen then
			maxLen = len
		end
	end

	for i = 1, maxLen do
		new[i] = {}

		for j = 1, argCount do
			local value = select(j, ...)[i]

			if value == nil then
				new[i][j] = None
			else
				new[i][j] = select(j, ...)[i]
			end
		end
	end

	return new
end

return zipAll
