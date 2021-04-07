local Typer = require(script.Parent.Parent.Parent.Typer)

local function copy(dictionary)
	local new = {}
	for key, value in next, dictionary do
		new[key] = value
	end

	return new
end

return Typer.AssignSignature(Typer.Table, copy)
