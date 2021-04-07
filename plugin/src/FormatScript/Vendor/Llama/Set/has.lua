local Typer = require(script.Parent.Parent.Parent.Typer)

local function has(set, key)
	return set[key] == true
end

return Typer.AssignSignature(Typer.Array, Typer.Any, has)
