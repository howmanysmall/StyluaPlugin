local Typer = require(script.Parent.Parent.Parent.Typer)

local function some(dictionary, predicate)
	for key, value in next, dictionary do
		if predicate(value, key) then
			return true
		end
	end

	return false
end

return Typer.AssignSignature(Typer.Table, Typer.Function, some)
