local Typer = require(script.Parent.Parent.Parent.Typer)

local Filter = Typer.AssignSignature(Typer.Array, Typer.Function, function(Array, Function)
	local NewArray = {}
	local Length = 0

	for Index, Value in ipairs(Array) do
		if Function(Value, Index, Array) then
			Length += 1
			NewArray[Length] = Value
		end
	end

	return NewArray
end)

return Filter
