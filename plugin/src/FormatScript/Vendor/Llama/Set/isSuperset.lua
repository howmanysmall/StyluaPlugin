local Typer = require(script.Parent.Parent.Parent.Typer)
local isSubset = require(script.Parent.isSubset)

local function isSuperset(superset, subset)
	return isSubset(subset, superset)
end

return Typer.AssignSignature(Typer.Table, Typer.Table, isSuperset)
