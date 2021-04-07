local Typer = require(script.Parent.Parent.Parent.Typer)
local join = require(script.Parent.join)

local function flatMap(dictionary, mapper)
	local new = {}
	for k, v in next, dictionary do
		if type(v) == "table" then
			new = join(flatMap(v, mapper), new)
		else
			local value, key = mapper(v, k)
			new[key or k] = value
		end
	end

	return new
end

return Typer.AssignSignature(Typer.Table, Typer.Function, flatMap)
