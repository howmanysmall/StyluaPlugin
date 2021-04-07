local Typer = require(script.Parent.Parent.Typer)

local function isEmpty(table)
	return next(table) == nil
end

return Typer.AssignSignature(Typer.Table, isEmpty)
