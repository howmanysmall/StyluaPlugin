local Typer = require(script.Parent.Parent.Parent.Typer)
local copy = require(script.Parent.copy)

local function set(dictionary, key, value)
	local new = copy(dictionary)
	new[key] = value
	return new
end

return Typer.AssignSignature(Typer.Table, Typer.Any, Typer.Any, set)
