local Typer = require(script.Parent.Parent.Parent.Typer)

local function flip(dictionary)
	local new = {}
	for key, value in next, dictionary do
		new[value] = key
	end

	return new
end

return Typer.AssignSignature(Typer.Table, flip)
