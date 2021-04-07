local Typer = require(script.Parent.Parent.Parent.Typer)

local function filter(set, filterer)
	local new = {}

	for key in next, set do
		if filterer(key) then
			new[key] = true
		end
	end

	return new
end

return Typer.AssignSignature(Typer.Table, Typer.Function, filter)
