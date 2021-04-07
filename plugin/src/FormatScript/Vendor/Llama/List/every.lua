local Typer = require(script.Parent.Parent.Parent.Typer)

local Every = Typer.AssignSignature(Typer.Array, Typer.Function, function(Array, Function)
	for Index, Value in ipairs(Array) do
		if not Function(Value, Index, Array) then
			return false
		end
	end

	return true
end)

return Every
