--[[
	Performs a left-fold of the list with the given initial value and callback.
]]
local function foldLeft(list, callback, initialValue)
	local accum = initialValue

	for i, v in ipairs(list) do
		accum = callback(accum, v, i)
	end

	return accum
end

return foldLeft