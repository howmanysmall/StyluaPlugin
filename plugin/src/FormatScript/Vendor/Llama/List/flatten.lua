local Typer = require(script.Parent.Parent.Parent.Typer)

type Array<Value> = {Value}
type int = number

local function FlattenHelper(Array: Array<any>, Length: int, DestinationArray: Array<any>): int
	for _, Value in ipairs(Array) do
		if type(Value) == "table" then
			Length = FlattenHelper(Value, Length, DestinationArray)
		else
			Length += 1
			DestinationArray[Length] = Value
		end
	end

	return Length
end

local function Flatten(Array: Array<any>): Array<any>
	local NewArray: Array<any> = {}
	FlattenHelper(Array, 0, NewArray)
	return NewArray
end

return Typer.AssignSignature(Typer.Array, Flatten)
