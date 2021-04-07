local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert
local Typer_Table = Typer.Table

local function union(...)
	local new = {}

	for i = 1, select("#", ...) do
		local set = Debug_Assert(Typer_Table(select(i, ...)))
		for key in next, set do
			new[key] = true
		end
	end

	return new
end

return union
