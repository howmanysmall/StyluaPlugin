local Typer = require(script.Parent.Parent.Parent.Typer)

local Every = Typer.AssignSignature(Typer.Table, Typer.Function, function(Dictionary, Function)
	for Key, Value in next, Dictionary do
		if not Function(Value, Key, Dictionary) then
			return false
		end
	end

	return true
end)

return Every
