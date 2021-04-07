local Typer = require(script.Parent.Parent.Parent.Typer)

local function toList(set)
	local new = {}
	local index = 1

	for key in next, set do
		new[index] = key
		index = index + 1
	end

	return new
end

return Typer.AssignSignature(Typer.Table, toList)
