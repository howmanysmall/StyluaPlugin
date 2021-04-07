local function intersect(...)
	local new = {}
	local argc = select("#", ...)
	local first = select(1, ...)

	for key in next, first do
		local intersects = true

		for index = 2, argc do
			if select(index, ...)[key] == nil then
				intersects = false
				break
			end
		end

		if intersects then
			new[key] = true
		end
	end

	return new
end

return intersect
