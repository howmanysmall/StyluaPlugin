local AutomatedScrollingFrameConnector = require(script.AutomatedScrollingFrameConnector)
local Llama = require(script.Parent.Parent.Vendor.Llama)
local Roact = require(script.Parent.Parent.Vendor.Roact)

local AutomatedScrollingFrame = Roact.PureComponent:extend("AutomatedScrollingFrame")

local Llama_Dictionary_copy = Llama.Dictionary.copy
local Roact_createElement = Roact.createElement

function AutomatedScrollingFrame:init()
	self.ref = self.props[Roact.Ref] or Roact.createRef()
end

function AutomatedScrollingFrame:render()
	local props = Llama_Dictionary_copy(self.props)
	props.Layout = nil
	props[Roact.Ref] = self.ref
	return Roact_createElement("ScrollingFrame", props)
end

function AutomatedScrollingFrame:didMount()
	local layout

	if self.props.Layout then
		layout = self.props.Layout:getValue()
	end

	AutomatedScrollingFrameConnector(self.ref:getValue(), layout)
end

return AutomatedScrollingFrame