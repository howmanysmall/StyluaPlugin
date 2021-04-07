local copy = require(script.Parent.copy)

local function shuffle(list)
	local newList = copy(list)
	local random = Random.new(tick() % 1 * 1E7)
	for index = #newList, 2, -1 do
		local jndex = random:NextInteger(1, index)
		newList[index], newList[jndex] = newList[jndex], newList[index]
	end

	return newList
end

return shuffle
