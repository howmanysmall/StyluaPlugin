local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert
local Typer_Table = Typer.Table

local function subtract(set, ...)
	Debug_Assert(Typer_Table(set))
	local new = {}

	for key in next, set do
		new[key] = true
	end

	for i = 1, select("#", ...) do
		new[select(i, ...)] = nil
	end

	return new
end

return subtract
