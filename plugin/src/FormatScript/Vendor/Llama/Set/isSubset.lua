local Typer = require(script.Parent.Parent.Parent.Typer)

local function isSubset(subset, superset)
	for key, value in next, subset do
		if superset[key] ~= value then
			return false
		end
	end

	return true
end

return Typer.AssignSignature(Typer.Table, Typer.Table, isSubset)
