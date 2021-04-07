local Typer = require(script.Parent.Parent.Parent.Typer)

local function reduceRight(list, reducer, initialReduction)
	local len = #list
	local reduction = initialReduction
	local start = len

	if reduction == nil then
		reduction = list[len]
		start = len - 1
	end

	for i = start, 1, -1 do
		reduction = reducer(reduction, list[i], i)
	end

	return reduction
end

return Typer.AssignSignature(Typer.Array, Typer.Function, Typer.Any, reduceRight)
