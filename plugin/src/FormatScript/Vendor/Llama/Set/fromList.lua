local Typer = require(script.Parent.Parent.Parent.Typer)

local function fromList(list)
	local set = {}
	for _, v in ipairs(list) do
		set[v] = true
	end

	return set
end

return Typer.AssignSignature(Typer.Array, fromList)
