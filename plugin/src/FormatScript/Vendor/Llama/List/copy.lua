local Typer = require(script.Parent.Parent.Parent.Typer)

local Copy = Typer.AssignSignature(Typer.Array, function(List)
	local NewArray = table.create(#List)
	for Index, Value in ipairs(List) do
		NewArray[Index] = Value
	end

	return NewArray
end)

return Copy
