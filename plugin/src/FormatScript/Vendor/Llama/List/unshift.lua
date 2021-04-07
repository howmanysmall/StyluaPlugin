local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert

local function unshift(list, ...)
	Debug_Assert(Typer.Array(list))
	local argCount = select("#", ...)

	local new = {}

	for i = 1, argCount do
		new[i] = select(i, ...)
	end

	for i = 1, #list do
		new[argCount + i] = list[i]
	end

	return new
end

return unshift
