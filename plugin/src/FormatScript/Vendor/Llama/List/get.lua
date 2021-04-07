local function get(list, index)
	assert(type(list) == "table", "expected a table for first argument, got " .. type(list))
	assert(type(index) == "number" and index % 1 == 0, "expected second argument to be an integer, got " .. type(index))

	return list[index]
end

return get