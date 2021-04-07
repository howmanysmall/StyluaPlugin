local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert

local function removeIndex(list, indexToRemove)
	local len = #list
	if indexToRemove < 1 then
		indexToRemove = len + indexToRemove
	end

	Debug_Assert(indexToRemove > 0 and indexToRemove <= len, "index %d out of bounds of list of length %d", indexToRemove, len)
	local new = table.create(len - 1)
	local index = 1

	for i, v in ipairs(list) do
		if i ~= indexToRemove then
			new[index] = v
			index = index + 1
		end
	end

	return new
end

return Typer.AssignSignature(Typer.Array, Typer.Integer, removeIndex)
