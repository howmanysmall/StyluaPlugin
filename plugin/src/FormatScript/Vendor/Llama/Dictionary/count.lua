local Typer = require(script.Parent.Parent.Parent.Typer)

local function alwaysTrue()
	return true
end

local function count(dictionary, predicate)
	predicate = predicate or alwaysTrue
	local counter = 0

	for key, value in next, dictionary do
		if predicate(value, key) then
			counter = counter + 1
		end
	end

	return counter
end

return Typer.AssignSignature(Typer.Table, Typer.OptionalFunction, count)
