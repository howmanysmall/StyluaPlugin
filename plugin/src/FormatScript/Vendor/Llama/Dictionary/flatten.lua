local Typer = require(script.Parent.Parent.Parent.Typer)

local function flatten(dictionary, depth)
	local new = {}

	for key, value in next, dictionary do
		if type(value) == "table" and (not depth or depth > 0) then
			local subDictionary = flatten(value, depth and depth - 1)

			for newKey, newValue in next, new do
				subDictionary[newKey] = newValue
			end

			new = subDictionary
		else
			new[key] = value
		end
	end

	return new
end

return Typer.AssignSignature(Typer.Table, Typer.OptionalNonNegativeInteger, flatten)
