local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert

local function pop(list, numPops)
	local len = #list
	numPops = numPops or 1
	Debug_Assert(numPops > 0 and numPops <= len + 1, "index %d out of bounds of list of length %d", numPops, len)

	local length = #list - numPops
	local new = table.create(length)

	for i = 1, length do
		new[i] = list[i]
	end

	return new
end

return Typer.AssignSignature(Typer.Array, Typer.OptionalNonNegativeInteger, pop)
