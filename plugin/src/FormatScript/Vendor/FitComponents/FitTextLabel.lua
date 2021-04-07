local TextService = game:GetService("TextService")

local Debug = require(script.Parent.Parent.Debug)
local Enumeration = require(script.Parent.Parent.Parent.Enumeration)
local Llama = require(script.Parent.Parent.Llama)
local Roact = require(script.Parent.Parent.Roact)

local FitTextLabel = Roact.PureComponent:extend("FitTextLabel")
FitTextLabel.Width = Enumeration.FitWidth

FitTextLabel.defaultProps = {
	Font = Enum.Font.SourceSans,
	MaximumWidth = math.huge,
	Text = "Label",
	TextSize = 12,
	TextWrapped = true,
}

local Debug_Assert = Debug.Assert
local Llama_Dictionary_join = Llama.Dictionary.join
local Llama_None = Llama.None
local Roact_createElement = Roact.createElement

local function getTextHeight(text: string, textSize: number, font: Enum.Font, widthCap: number): number
	return TextService:GetTextSize(text, textSize, font, Vector2.new(widthCap, 10000)).Y + 2
end

local function getTextWidth(text: string, textSize: number, font: Enum.Font): number
	return TextService:GetTextSize(text, textSize, font, Vector2.new(10000, 10000)).X + 2
end

local function GetSize(this, rbx)
	local self = this
	local props = self.props

	local maximumWidth = props.MaximumWidth
	local width = Debug_Assert(Enumeration.FitWidth.Cast(props.Width))
	if width == Enumeration.FitWidth.FitToText then
		local textWidth = getTextWidth(props.Text, props.TextSize, props.Font)
		width = UDim.new(0, math.min(textWidth, maximumWidth))
	end

	local widthCap = math.max(maximumWidth < math.huge and maximumWidth or 0, rbx.AbsoluteSize.X)
	local textHeight = getTextHeight(props.Text, props.TextSize, props.Font, widthCap)

	return UDim2.new(width, UDim.new(0, textHeight))
end

function FitTextLabel:init()
	self.frameRef = Roact.createRef()

	self.onResize = function()
		local current = self.frameRef.current
		if not current then
			return
		end

		current.Size = GetSize(self, current)
	end
end

local function GetFilteredProps(this)
	-- Will return a new prop map after removing
	-- Roact.Children and any defaultProps in an effort
	-- to only return safe Roblox Instance "TextLabel"
	-- properties that may be present.
	local self = this
	local props = self.props

	local filteredProps = {
		MaximumWidth = Llama_None,
		OnActivated = Llama_None,
		Size = UDim2.new(props.Width, UDim.new()),
		Width = Llama_None,

		[Roact.Ref] = self.frameRef,
		[Roact.Children] = Llama_Dictionary_join(props[Roact.Children] or {}, {
			SizeConstraint = props.MaximumWidth < math.huge and Roact_createElement("UISizeConstraint", {
				MaxSize = Vector2.new(props.MaximumWidth, math.huge),
			}),
		}),

		[Roact.Event.Activated] = props.OnActivated,
		[Roact.Change.AbsoluteSize] = function(rbx)
			if props[Roact.Change.AbsoluteSize] then
				props[Roact.Change.AbsoluteSize](rbx)
			end

			self.onResize()
		end,
	}

	return Llama_Dictionary_join(props, filteredProps)
end

function FitTextLabel:render()
	local instanceType = self.props.OnActivated and "TextButton" or "TextLabel"
	return Roact_createElement(instanceType, GetFilteredProps(self))
end

function FitTextLabel:didMount()
	self.onResize()
end

function FitTextLabel:didUpdate()
	self.onResize()
end

return FitTextLabel
