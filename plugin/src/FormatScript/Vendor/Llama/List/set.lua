local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert

local function set(list, index, value)
	local len = #list
	if index < 0 then
		index = len + index
	end

	Debug_Assert(index > 0 and index <= len + 1, "index %d out of bounds of list of length %d", index, len)
	local new = {}
	local indexNew = 1

	for i = 1, len do
		if i == index then
			new[indexNew] = value
		else
			new[indexNew] = list[i]
		end

		indexNew = indexNew + 1
	end

	return new
end

return Typer.AssignSignature(Typer.Array, Typer.Integer, Typer.Any, set)
