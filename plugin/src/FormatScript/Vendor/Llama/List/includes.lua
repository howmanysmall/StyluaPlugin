local Typer = require(script.Parent.Parent.Parent.Typer)

local function includes(list, value)
	return table.find(list, value) ~= nil
end

return Typer.AssignSignature(Typer.Array, Typer.Any, includes)
