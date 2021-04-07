local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert
local validate = Typer.Array

local function push(list, ...)
	Debug_Assert(validate(list))

	local new = {}
	local len = #list

	for i = 1, len do
		new[i] = list[i]
	end

	for i = 1, select("#", ...) do
		new[len + i] = select(i, ...)
	end

	return new
end

return push
