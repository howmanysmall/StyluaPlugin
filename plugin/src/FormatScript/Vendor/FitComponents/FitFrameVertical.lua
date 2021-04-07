local Enumeration = require(script.Parent.Parent.Parent.Enumeration)
local FitFrameOnAxis = require(script.Parent.FitFrameOnAxis)
local Llama = require(script.Parent.Parent.Llama)
local Roact = require(script.Parent.Parent.Roact)

local Llama_Dictionary_join = Llama.Dictionary.join
local Llama_None = Llama.None
local Roact_createElement = Roact.createElement

local function FitFrameVertical(props)
	props = props or {}
	local width = props.Width

	local filteredProps = Llama_Dictionary_join(props, {
		Axis = Enumeration.FitAxis.Vertical,
		MinimumSize = UDim2.new(width, UDim.new()),
		Width = Llama_None,
	})

	return Roact_createElement(FitFrameOnAxis, filteredProps)
end

return FitFrameVertical
