local Typer = require(script.Parent.Parent.Parent.Typer)

local function removeValue(dictionary, valueToRemove)
	local new = {}

	for key, value in next, dictionary do
		if value ~= valueToRemove then
			new[key] = value
		end
	end

	return new
end

return Typer.AssignSignature(Typer.Table, Typer.NonNil, removeValue)
