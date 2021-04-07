local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert
local Typer_Check = Typer.Check

local Array = Typer.Array
local OptionalInteger = Typer.OptionalInteger

local function splice(list, from, to, ...)
	Debug_Assert(Typer_Check(Array, list, "List"))
	Debug_Assert(Typer_Check(OptionalInteger, list, "From"))
	Debug_Assert(Typer_Check(OptionalInteger, list, "To"))

	local len = #list

	from = from or 1
	to = to or len + 1

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

	for i = 1, from - 1 do
		new[index] = list[i]
		index = index + 1
	end

	for i = 1, select("#", ...) do
		new[index] = select(i, ...)
		index = index + 1
	end

	for i = to + 1, len do
		new[index] = list[i]
		index = index + 1
	end

	return new
end

return splice
