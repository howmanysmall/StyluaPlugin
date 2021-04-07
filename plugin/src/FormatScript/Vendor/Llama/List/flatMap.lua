local Typer = require(script.Parent.Parent.Parent.Typer)

type Array<Value> = {Value}
type int = number
type MapFunction = (any, int, Array<any>) -> any?

local function FlattenHelper(Array: Array<any>, Function: MapFunction, Length: int, DestinationArray: Array<any>): int
	for Index, Value in ipairs(Array) do
		if type(Value) == "table" then
			Length = FlattenHelper(Value, Function, Length, DestinationArray)
		else
			local NewValue = Function(Value, Index, Array)
			if NewValue ~= nil then
				Length += 1
				DestinationArray[Length] = NewValue
			end
		end
	end

	return Length
end

local function FlatMap(Array: Array<any>, Function: MapFunction): Array<any>
	local NewArray: Array<any> = {}
	FlattenHelper(Array, Function, 0, NewArray)
	return NewArray
end

return Typer.AssignSignature(Typer.Array, Typer.Function, FlatMap)

-- local function flatMap(list, mapper)
-- 	assert(type(list) == "table", "expected a table for first argument, got " .. type(list))
-- 	assert(type(mapper) == "function", "expected a function for second argument, got " .. type(mapper))

-- 	local new = {}
-- 	local index = 1

-- 	for i, v in ipairs(list) do
-- 		if type(v) == "table" then
-- 			for _, value in ipairs(flatMap(v, mapper)) do
-- 				new[index] = value
-- 				index += 1
-- 			end
-- 		else
-- 			local value = mapper(v, i)
-- 			if value ~= nil then
-- 				new[index] = value
-- 				index += 1
-- 			end
-- 		end
-- 	end

-- 	return new
-- end

-- return flatMap
