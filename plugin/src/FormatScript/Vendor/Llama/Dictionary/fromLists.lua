local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert

local function fromLists(keys, values)
	local keysLen = #keys
	Debug_Assert(keysLen == #values, "lists must be same size")
	local dictionary = {}

	for i = 1, keysLen do
		dictionary[keys[i]] = values[i]
	end

	return dictionary
end

return Typer.AssignSignature(Typer.Array, Typer.Array, fromLists)
