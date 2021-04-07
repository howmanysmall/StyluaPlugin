local Typer = require(script.Parent.Parent.Parent.Typer)

local function AlwaysTrue()
	return true
end

local Count = Typer.AssignSignature(Typer.Array, Typer.OptionalFunction, function(List, Predicate)
	Predicate = Predicate or AlwaysTrue

	local Counter = 0
	for Index, Value in ipairs(List) do
		if Predicate(Value, Index) then
			Counter += 1
		end
	end

	return Counter
end)

return Count
