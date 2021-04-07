local Typer = require(script.Parent.Parent.Parent.Typer)

local function filter(dictionary, filterer)
	local new = {}

	for key, value in next, dictionary do
		if filterer(value, key) then
			new[key] = value
		end
	end

	return new
end

return Typer.AssignSignature(Typer.Table, Typer.Function, filter)
