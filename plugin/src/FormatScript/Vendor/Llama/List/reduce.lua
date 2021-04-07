local Typer = require(script.Parent.Parent.Parent.Typer)

local function reduce(list, reducer, initialReduction)
	local reduction = initialReduction
	local start = 1

	if reduction == nil then
		reduction = list[1]
		start = 2
	end

	for i = start, #list do
		reduction = reducer(reduction, list[i], i)
	end

	return reduction
end

return Typer.AssignSignature(Typer.Array, Typer.Function, Typer.Any, reduce)
