local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)
local copy = require(script.Parent.copy)

local Debug_Assert = Debug.Assert
local Typer_Table = Typer.Table

local function removeKeys(dictionary, ...)
	Debug_Assert(Typer_Table(dictionary))
	local new = copy(dictionary)

	for i = 1, select("#", ...) do
		new[select(i, ...)] = nil
	end

	return new
end

return removeKeys
