local Typer = require(script.Parent.Parent.Parent.Typer)

local function removeValue(list, value)
	local new = {}
	local index = 1

	for _, v in ipairs(list) do
		if v ~= value then
			new[index] = v
			index = index + 1
		end
	end

	return new
end

return Typer.AssignSignature(Typer.Array, Typer.Any, removeValue)
