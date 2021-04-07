local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert

local function findWhere(list, predicate, from)
	local len = #list
	from = from or 1
	if from < 1 then
		from = len + from
	end

	Debug_Assert(from > 0 and from <= len + 1, "index %d out of bounds of list of length %d", from, len)
	for i = from, len do
		if predicate(list[i], i) then
			return i
		end
	end

	return nil
end

return Typer.AssignSignature(Typer.Array, Typer.Function, Typer.OptionalInteger, findWhere)
