local Typer = require(script.Parent.Parent.Parent.Typer)

local function keys(dictionary)
	local keysList = {}
	local index = 1

	for key in next, dictionary do
		keysList[index] = key
		index = index + 1
	end

	return keysList
end

return Typer.AssignSignature(Typer.Table, keys)
