local function extend(original, extension)
	local new = table.create(#original + #extension)
	for key, value in next, original do
		new[key] = value
	end

	for key, value in next, extension do
		new[key] = value
	end

	return new
end

return extend
