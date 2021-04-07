local Typer = require(script.Parent.Parent.Parent.Typer)
local copy = require(script.Parent.copy)

local function removeKey(dictionary, key)
	local new = copy(dictionary)
	new[key] = nil
	return new
end

return Typer.AssignSignature(Typer.Table, Typer.NonNil, removeKey)
