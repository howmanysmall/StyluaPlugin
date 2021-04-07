local Debug = require(script.Parent.Parent.Debug)
local Enumeration = require(script.Parent.Parent.Parent.Enumeration)
local FitFrameOnAxis = require(script.Parent.FitFrameOnAxis)
local Llama = require(script.Parent.Parent.Llama)
local Roact = require(script.Parent.Parent.Roact)
local Square = require(script.Parent.Square)
local Typer = require(script.Parent.Parent.Typer)

local FitFrameOnAxis = Roact.PureComponent:extend("FitFrameOnAxis")
FitFrameOnAxis.Axis = Enumeration.FitAxis

FitFrameOnAxis.defaultProps = {
	Axis = Enumeration.FitAxis.Vertical,
	ContentPadding = UDim.new(),
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	ImageSet = {},
	Margin = Square.Square(0),
	MinimumSize = UDim2.new(),
	TextProps = nil,
	VerticalAlignment = Enum.VerticalAlignment.Top,
}

local MarginDefinition = Typer.MapStrictDefinition({
	Bottom = Typer.Number,
	Left = Typer.Number,
	Right = Typer.Number,
	Top = Typer.Number,
})

FitFrameOnAxis.validateProps = Typer.MapDefinition({
	Axis = Typer.OptionalEnumerationOfTypeFitAxis,
	ContentPadding = Typer.OptionalUDim,
	FillDirection = Typer.OptionalEnumOfTypeFillDirection,
	HorizontalAlignment = Typer.OptionalEnumOfTypeHorizontalAlignment,
	ImageSet = Typer.OptionalTable,
	Margin = {"nil", Margin = MarginDefinition},
	MinimumSize = Typer.OptionalUDim2,
	TextProps = Typer.OptionalTable,
	VerticalAlignment = Typer.OptionalEnumOfTypeVerticalAlignment,
})

local Debug_Assert = Debug.Assert
local Llama_Dictionary_join = Llama.Dictionary.join
local Llama_None = Llama.None
local Roact_createElement = Roact.createElement

local function GetFilteredProps(this)
	-- Will return a new prop map after removing
	-- Roact.Children and any defaultProps in an effort
	-- to only return safe Roblox Instance "ImageLabel"
	-- properties that may be present.

	local self = this
	local props = self.props

	local filteredProps = Llama_Dictionary_join(props.ImageSet, {
		[Roact.Event.Activated] = props.OnActivated,
		[Roact.Ref] = self.frameRef,
	})

	for property in next, FitFrameOnAxis.defaultProps do
		filteredProps[property] = Llama_None
	end

	filteredProps.TextProps = Llama_None
	return Llama_Dictionary_join(props, filteredProps, {
		OnActivated = Llama_None,
		[Roact.Children] = Llama_None,
	})
end

local function GetBothAxisSize(this, currentLayout)
	local self = this
	local props = self.props
	local minimumSize = props.MinimumSize
	local margin = props.Margin
	local absoluteContentSize = currentLayout.AbsoluteContentSize

	return UDim2.new(minimumSize.X.Scale, absoluteContentSize.X + margin.Left + margin.Right, minimumSize.Y.Scale, absoluteContentSize.Y + margin.Top + margin.Bottom)
end

-- local function GetVerticalMargin(this)
-- 	local self = this
-- 	local margin = self.props.Margin
-- 	return margin.Top + margin.Bottom
-- end

-- local function GetHorizontalMargin(this)
-- 	local self = this
-- 	local margin = self.props.Margin
-- 	return margin.Left + margin.Right
-- end

-- local function GetAxisUDim(this, vector2)
-- 	-- Merges minimumSize with given Vector2
-- 	-- to create UDim for primary axis
-- 	local self = this
-- 	local props = self.props
-- 	local axis = props.Axis
-- 	local margin = props.Margin

-- 	local targetUDim
-- 	local lengthOfChildren
-- 	if axis == FrameAxis.Vertical then
-- 		targetUDim = props.MinimumSize.Y
-- 		lengthOfChildren = vector2.AbsoluteContentSize.Y + margin.Top + margin.Bottom
-- 	else
-- 		targetUDim = props.MinimumSize.X
-- 		lengthOfChildren = vector2.AbsoluteContentSize.X + margin.Left + margin.Right
-- 	end

-- 	return UDim.new(targetUDim.Scale, math.max(lengthOfChildren, targetUDim.Offset))
-- end

-- local function GetOtherUDim(this)
-- 	-- Since there is no primary axis to merge with,
-- 	-- this UDim is entirely represented by minimumSize
-- 	local self = this
-- 	local props = self.props
-- 	local axis = props.Axis

-- 	if axis == FrameAxis.Vertical then
-- 		return props.MinimumSize.X
-- 	elseif axis == FrameAxis.Horizontal then
-- 		return props.MinimumSize.Y
-- 	end
-- end

local function GetSize(this, currentLayout)
	local self = this
	local props = self.props
	local axis = Debug_Assert(Enumeration.FitAxis.Cast(props.Axis))

	if axis == Enumeration.FitAxis.Both then
		return GetBothAxisSize(self, currentLayout)
	else
		-- Arrangement of UDims are flip-flopped based
		-- on which axis is our primary axis
		local minimumSize = props.MinimumSize
		local margin = props.Margin
		local targetUDim
		local lengthOfChildren

		local isVertical = axis == Enumeration.FitAxis.Vertical

		if isVertical then
			targetUDim = minimumSize.Y
			lengthOfChildren = currentLayout.AbsoluteContentSize.Y + margin.Top + margin.Bottom
		else
			targetUDim = minimumSize.X
			lengthOfChildren = currentLayout.AbsoluteContentSize.X + margin.Left + margin.Right
		end

		local axisUDim = UDim.new(targetUDim.Scale, math.max(lengthOfChildren, targetUDim.Offset))
		local otherUDim = isVertical and minimumSize.X or minimumSize.Y

		if isVertical then
			return UDim2.new(otherUDim, axisUDim)
		else
			return UDim2.new(axisUDim, otherUDim)
		end
	end
end

function FitFrameOnAxis:init(props)
	self.layoutRef = Roact.createRef()
	self.frameRef = props[Roact.Ref] or Roact.createRef()

	self.onResize = function()
		local currentLayout = self.layoutRef.current
		local currentFrame = self.frameRef.current
		if not currentFrame or not currentLayout then
			return
		end

		currentFrame.Size = GetSize(self, currentLayout)
	end
end

function FitFrameOnAxis:render()
	local props = self.props
	Debug_Assert(props.Size == nil, "Size is not a valid property of FitFrameOnAxis. Did you mean `MinimumSize`?")
	local children = props[Roact.Children] or {}
	local filteredProps = GetFilteredProps(self)

	local instanceType = props.OnActivated and "ImageButton" or "ImageLabel"
	local margin = props.Margin

	children = Llama_Dictionary_join(children, {
		["$UIListLayout"] = Roact_createElement("UIListLayout", {
			FillDirection = props.FillDirection,
			HorizontalAlignment = props.HorizontalAlignment,
			Padding = props.ContentPadding,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = props.VerticalAlignment,

			[Roact.Change.AbsoluteContentSize] = self.onResize,
			[Roact.Ref] = self.layoutRef,
		}),

		["$UIPadding"] = Roact_createElement("UIPadding", {
			PaddingLeft = UDim.new(0, margin.Left),
			PaddingRight = UDim.new(0, margin.Right),
			PaddingTop = UDim.new(0, margin.Top),
			PaddingBottom = UDim.new(0, margin.Bottom),
		}),
	})

	if props.TextProps then
		return Roact_createElement(instanceType, filteredProps, {
			TextLabel = Roact_createElement("TextLabel", Llama_Dictionary_join(props.TextProps, {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
			})),

			ChildFrame = Roact_createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
			}, children),
		})
	else
		return Roact_createElement(instanceType, filteredProps, children)
	end
end

function FitFrameOnAxis:didMount()
	self.onResize()
end

function FitFrameOnAxis:didUpdate()
	self.onResize()
end

return FitFrameOnAxis
