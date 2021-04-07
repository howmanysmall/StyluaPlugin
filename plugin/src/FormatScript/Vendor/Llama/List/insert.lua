local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert
local Typer_Check = Typer.Check

local Array = Typer.Array
local OptionalInteger = Typer.OptionalInteger

local function insert(list, index, ...)
	Debug_Assert(Typer_Check(Array, list, "List"))
	Debug_Assert(Typer_Check(Array, OptionalInteger, "Index"))
	local len = #list
	if index < 1 then
		index = len + index
	end

	Debug_Assert(index > 0 and index <= len + 1, "index %d out of bounds of list of length %d", index, len)
	local new = {}
	local resultIndex = 1

	for i = 1, len do
		if i == index then
			for j = 1, select("#", ...) do
				new[resultIndex] = select(j, ...)
				resultIndex = resultIndex + 1
			end
		end

		new[resultIndex] = list[i]
		resultIndex = resultIndex + 1
	end

	return new
end

return insert
