local Typer = require(script.Parent.Parent.Parent.Typer)

local Last = Typer.AssignSignature(Typer.Array, function(Array)
	return Array[#Array]
end)

return Last
