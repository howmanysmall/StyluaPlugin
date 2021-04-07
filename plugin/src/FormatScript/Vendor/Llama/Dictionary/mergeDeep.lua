local Debug = require(script.Parent.Parent.Parent.Debug)
local None = require(script.Parent.Parent.None)
local Typer = require(script.Parent.Parent.Parent.Typer)
local copyDeep = require(script.Parent.copyDeep)

local Debug_Assert = Debug.Assert
local Typer_Table = Typer.Table

local function mergeDeep(...)
	local new = {}

	for dictionaryIndex = 1, select("#", ...) do
		local dictionary = select(dictionaryIndex, ...)

		if dictionary ~= nil then
			Debug_Assert(Typer_Table(dictionary))

			for key, value in next, dictionary do
				if value == None then
					new[key] = nil
				elseif type(value) == "table" then
					if new[key] == nil or type(new[key]) ~= "table" then
						new[key] = copyDeep(value)
					else
						new[key] = mergeDeep(new[key], value)
					end
				else
					new[key] = value
				end
			end
		end
	end

	return new
end

return mergeDeep
