local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert

local function shift(list, numPlaces)
	local len = #list
	numPlaces = numPlaces or 1
	Debug_Assert(numPlaces > 0 and numPlaces <= len + 1, "index %d out of bounds of list of length %d", numPlaces, len)

	local new = {}

	for i = 1 + numPlaces, len do
		new[i - numPlaces] = list[i]
	end

	return new
end

return Typer.AssignSignature(Typer.Array, Typer.OptionalNonNegativeInteger, shift)
