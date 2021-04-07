local Typer = require(script.Parent.Parent.Parent.Typer)

local Map = Typer.AssignSignature(Typer.Array, Typer.Function, function(Array, Function)
	local NewArray = {}
	local Length = 0

	for Index, Value in ipairs(Array) do
		local NewValue = Function(Value, Index, Array)
		if NewValue ~= nil then
			Length += 1
			NewArray[Length] = NewValue
		end
	end

	return NewArray
end)

return Map
