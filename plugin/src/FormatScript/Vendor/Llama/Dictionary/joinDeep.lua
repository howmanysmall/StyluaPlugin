local None = require(script.Parent.Parent.None)
local copyDeep = require(script.Parent.copyDeep)

local function joinDeep(...)
	local new = {}

	for dictionaryIndex = 1, select("#", ...) do
		local dictionary = select(dictionaryIndex, ...)

		for key, value in next, dictionary do
			if value == None then
				new[key] = nil
			elseif type(value) == "table" then
				if new[key] == nil or type(new[key]) ~= "table" then
					new[key] = copyDeep(value)
				else
					new[key] = joinDeep(new[key], value)
				end
			else
				new[key] = value
			end
		end
	end

	return new
end

return joinDeep
