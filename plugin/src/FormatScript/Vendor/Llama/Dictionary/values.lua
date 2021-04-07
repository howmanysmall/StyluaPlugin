local Typer = require(script.Parent.Parent.Parent.Typer)

local function values(dictionary)
	local valuesList = {}
	local index = 1

	for _, value in next, dictionary do
		valuesList[index] = value
		index = index + 1
	end

	return valuesList
end

return Typer.AssignSignature(Typer.Table, values)
