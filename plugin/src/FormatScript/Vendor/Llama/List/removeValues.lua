local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)
local toSet = require(script.Parent.toSet)

local Debug_Assert = Debug.Assert

local function removeValue(list, ...)
	Debug_Assert(Typer.Array(list))
	local valuesSet = toSet({...})
	local new = {}
	local index = 1

	for i = 1, #list do
		if not valuesSet[list[i]] then
			new[index] = list[i]
			index = index + 1
		end
	end

	return new
end

return removeValue
