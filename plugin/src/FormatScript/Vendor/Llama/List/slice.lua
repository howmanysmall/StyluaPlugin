local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert
local function slice(list, from, to)
	local len = #list
	from = from or 1
	to = to or len

	if from < 1 then
		from = len + from
	end

	if to < 1 then
		to = len + to
	end

	Debug_Assert(from > 0 and from <= len + 1, "index %d out of bounds of list of length %d", from, len)
	Debug_Assert(to > 0 and to <= len + 1, "index %d out of bounds of list of length %d", to, len)
	Debug_Assert(from <= to, "start index %d cannot be greater than end index %d", from, to)

	local new = {}
	local index = 1

	for i = from, to do
		new[index] = list[i]
		index = index + 1
	end

	return new
end

return Typer.AssignSignature(Typer.Array, Typer.OptionalNonNegativeInteger, Typer.OptionalNonNegativeInteger, slice)
