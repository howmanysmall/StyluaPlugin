local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)
local Debug_Assert = Debug.Assert

local FindLast = Typer.AssignSignature(Typer.Array, Typer.OptionalAny, Typer.OptionalInteger, function(Array, Value, From)
	local Length = #Array
	if Length <= 0 then
		return nil
	end

	From = From or Length
	if From < 1 then
		From = Length + From
	end

	Debug_Assert(From > 0 and From <= Length + 1, "index %d out of bounds of list of length %d", From, Length)
	for Index = From, 1, -1 do
		if Array[Index] == Value then
			return Index
		end
	end

	return nil
end)

return FindLast
