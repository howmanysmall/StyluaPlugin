local None = require(script.Parent.Parent.None)

local function join(...)
	local new = {}
	local index = 1

	for listIndex = 1, select("#", ...) do
		local list = select(listIndex, ...)

		if list then
			for _, value in ipairs(list) do
				if value == None then
					continue
				end

				new[index] = value
				index += 1
			end
		end
	end

	return new
end

return join
