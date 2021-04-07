local Typer = require(script.Parent.Parent.Parent.Typer)
local copy = require(script.Parent.copy)

local function sort(list, comparator)
	local new = copy(list)
	table.sort(new, comparator)
	return new
end

return Typer.AssignSignature(Typer.Array, Typer.OptionalFunction, sort)
