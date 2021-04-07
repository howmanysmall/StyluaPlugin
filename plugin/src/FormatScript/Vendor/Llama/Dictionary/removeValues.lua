local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)
local toSet = require(script.Parent.Parent.List.toSet)

local Debug_Assert = Debug.Assert
local Typer_Table = Typer.Table

local function removeValues(dictionary, ...)
	Debug_Assert(Typer_Table(dictionary))
	local valuesSet = toSet({...})
	local new = {}

	for key, value in next, dictionary do
		if not valuesSet[value] then
			new[key] = value
		end
	end

	return new
end

return removeValues
