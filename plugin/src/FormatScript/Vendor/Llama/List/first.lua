local Typer = require(script.Parent.Parent.Parent.Typer)

local First = Typer.AssignSignature(Typer.Array, function(Array)
	return Array[1]
end)

return First
