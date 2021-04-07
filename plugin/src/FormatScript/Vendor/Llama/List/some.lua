local Typer = require(script.Parent.Parent.Parent.Typer)

local function some(list, predicate)
	for i, v in ipairs(list) do
		if predicate(v, i) then
			return true
		end
	end

	return false
end

return Typer.AssignSignature(Typer.Array, Typer.Function, some)
