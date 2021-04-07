local Enumeration = require(script.Parent.Parent.Parent.Enumeration)
local FitFrameOnAxis = require(script.Parent.FitFrameOnAxis)
local Llama = require(script.Parent.Parent.Llama)
local Roact = require(script.Parent.Parent.Roact)

local Llama_Dictionary_join = Llama.Dictionary.join
local Llama_None = Llama.None
local Roact_createElement = Roact.createElement

local function FitFrameHorizontal(props)
	props = props or {}
	local height = props.Height

	local filteredProps = Llama_Dictionary_join(props, {
		Axis = Enumeration.FitAxis.Horizontal,
		Height = Llama_None,
		MinimumSize = UDim2.new(UDim.new(), height),
	})

	return Roact_createElement(FitFrameOnAxis, filteredProps)
end

return FitFrameHorizontal
