local Typer = require(script.Parent.Parent.Parent.Typer)

local function CopyDeep(List)
	local NewArray = table.create(#List)
	for Index, Value in ipairs(List) do
		if type(Value) == "table" then
			NewArray[Index] = CopyDeep(Value)
		else
			NewArray[Index] = Value
		end
	end

	return NewArray
end

return Typer.AssignSignature(Typer.Array, CopyDeep)
