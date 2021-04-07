--[[
	Combine a number of dictionary-like tables into a new table.
	Keys specified in later tables will overwrite keys in previous tables.
]]
local function joinNoNone(...)
	local new = {}

	for i = 1, select("#", ...) do
		local source = select(i, ...)

		for key, value in next, source do
			new[key] = value
		end
	end

	return new
end

return joinNoNone
