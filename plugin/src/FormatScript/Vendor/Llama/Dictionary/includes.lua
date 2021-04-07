local Typer = require(script.Parent.Parent.Parent.Typer)

local function includes(dictionary, value)
	for _, v in next, dictionary do
		if v == value then
			return true
		end
	end

	return false
end

return Typer.AssignSignature(Typer.Table, Typer.Any, includes)
