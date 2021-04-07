local Typer = require(script.Parent.Parent.Parent.Typer)

local function get(dictionary, key)
	return dictionary[key]
end

return Typer.AssignSignature(Typer.Table, Typer.NonNil, get)
