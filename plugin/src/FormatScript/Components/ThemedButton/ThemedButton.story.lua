local Roact = require(script.Parent.Parent.Parent.Vendor.Roact)
local ThemedButton = require(script.Parent)

local function ThemedButtonStory()
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		ThemedButton = Roact.createElement(ThemedButton, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0.85, 0, 0, 24),
			TextSize = 20,
			Text = "ThemedButton",
			Font = Enum.Font.SourceSans,
			Position = UDim2.fromScale(0.5, 0.5),
		}),
	})
end

return function(Target)
	local Tree = Roact.mount(Roact.createElement(ThemedButtonStory), Target, "ThemedButtonStory")
	return function()
		Roact.unmount(Tree)
	end
end
