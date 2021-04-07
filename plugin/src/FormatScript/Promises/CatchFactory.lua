local Types = require(script.Parent.Parent.Types)
type CatchFunction = Types.CatchFunction

local CatchFunctions = setmetatable({}, {
	__index = function(self, Index): CatchFunction
		local function Value(Error: string)
			warn(string.format("Error in function %s: %s", Index, tostring(Error)))
		end

		self[Index] = Value
		return Value
	end;
})

local function CatchFactory(FunctionName: string): CatchFunction
	return CatchFunctions[FunctionName]
end

return CatchFactory