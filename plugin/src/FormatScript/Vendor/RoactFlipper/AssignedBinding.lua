local AssignedBinding = newproxy(true)
getmetatable(AssignedBinding).__tostring = function()
	return "Symbol(AssignedBinding)"
end

return AssignedBinding