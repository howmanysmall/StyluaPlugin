local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert

local function removeIndices(list, ...)
	Debug_Assert(Typer.Array(list))

	local len = #list
	local indicesToRemove = {}

	for i = 1, select("#", ...) do
		local index = select(i, ...)
		Debug_Assert(Typer.Integer(index))

		if index < 1 then
			index = len + index
		end

		Debug_Assert(index > 0 and index <= len, "index %d out of bounds of list of length %d", index, len)
		indicesToRemove[index] = true
	end

	local new = {}
	local index = 1

	for i = 1, len do
		if not indicesToRemove[i] then
			new[index] = list[i]
			index = index + 1
		end
	end

	return new
end

return removeIndices
