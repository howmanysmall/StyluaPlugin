local Typer = require(script.Parent.Parent.Parent.Typer)

local function reverse(list)
	local len = #list
	local new = table.create(len)
	local back = len + 1

	for i = 1, len do
		new[i] = list[back - i]
	end

	return new
end

return Typer.AssignSignature(Typer.Array, reverse)
