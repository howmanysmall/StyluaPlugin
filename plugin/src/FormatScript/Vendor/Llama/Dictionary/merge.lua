local Debug = require(script.Parent.Parent.Parent.Debug)
local None = require(script.Parent.Parent.None)
local Typer = require(script.Parent.Parent.Parent.Typer)

local Debug_Assert = Debug.Assert
local Typer_Table = Typer.Table

local function merge(...)
	local new = {}

	for dictionaryIndex = 1, select("#", ...) do
		local dictionary = select(dictionaryIndex, ...)

		if dictionary ~= nil then
			Debug_Assert(Typer_Table(dictionary))

			for key, value in pairs(dictionary) do
				if value == None then
					new[key] = nil
				else
					new[key] = value
				end
			end
		end
	end

	return new
end

return merge
