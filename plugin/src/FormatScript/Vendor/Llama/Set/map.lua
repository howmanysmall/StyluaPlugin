local Typer = require(script.Parent.Parent.Parent.Typer)

local function map(set, mapper)
	local new = {}
	for key in next, set do
		local newKey = mapper(key)
		if newKey ~= nil then
			new[newKey] = true
		end
	end

	return new
end

return Typer.AssignSignature(Typer.Table, Typer.Function, map)
