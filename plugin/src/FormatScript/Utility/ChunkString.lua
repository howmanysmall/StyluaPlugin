local function ChunkString(String: string, Size: number)
	local Index = 0
	local EndSize = math.ceil(#String / Size)

	return function(CurrentString: string)
		Index += 1
		if Index <= EndSize then
			return Index, string.sub(CurrentString, (Index - 1) * Size + 1, Index * Size)
		end
	end, String, nil
end

return ChunkString