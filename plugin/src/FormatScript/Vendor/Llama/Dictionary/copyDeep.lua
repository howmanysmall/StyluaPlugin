local Typer = require(script.Parent.Parent.Parent.Typer)

local function copyDeep(dictionary)
	local new = {}

	for key, value in next, dictionary do
		if type(value) == "table" then
			new[key] = copyDeep(value)
		else
			new[key] = value
		end
	end

	return new
end

return Typer.AssignSignature(Typer.Table, copyDeep)
