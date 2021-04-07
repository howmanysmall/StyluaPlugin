local Typer = require(script.Parent.Parent.Parent.Typer)

local function map(dictionary, mapper)
	local new = {}

	for key, value in next, dictionary do
		local newValue, newKey = mapper(value, key)
		new[newKey or key] = newValue
	end

	return new
end

return Typer.AssignSignature(Typer.Table, Typer.Function, map)
