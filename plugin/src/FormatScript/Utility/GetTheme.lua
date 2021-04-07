local Llama = require(script.Parent.Parent.Vendor.Llama)
local StudioStyleGuideColors = Enum.StudioStyleGuideColor:GetEnumItems()
local StudioStyleGuideModifiers = Enum.StudioStyleGuideModifier:GetEnumItems()

local CONSTANTS = {
	TextBox = {
		Font = Enum.Font.SourceSansSemibold;
	};
}

local function GetTheme()
	---@type StudioTheme
	local StudioTheme = settings().Studio.Theme
	local Theme = Llama.Dictionary.join({
		ThemeName = StudioTheme.Name;
	}, CONSTANTS)

	for _, StudioStyleGuideColor in ipairs(StudioStyleGuideColors) do
		local Color = {}
		for _, StudioStyleGuideModifier in ipairs(StudioStyleGuideModifiers) do
			Color[StudioStyleGuideModifier.Name] = StudioTheme:GetColor(StudioStyleGuideColor, StudioStyleGuideModifier)
		end

		Theme[StudioStyleGuideColor.Name] = Color
	end

	return Theme
end

return GetTheme
