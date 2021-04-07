local None = require(script.Parent.Parent.None)
local Typer = require(script.Parent.Parent.Parent.Typer)
local copyDeep = require(script.Parent.copyDeep)

local validate = Typer.Array

local function concatDeep(...)
	local new = {}
	local index = 1

	for listIndex = 1, select("#", ...) do
		local list = select(listIndex, ...)

		if list ~= nil then
			assert(validate(list))

			for _, value in ipairs(list) do
				if value ~= None then
					if type(value) == "table" then
						new[index] = copyDeep(value)
					else
						new[index] = value
					end

					index = index + 1
				end
			end
		end
	end

	return new
end

return concatDeep
