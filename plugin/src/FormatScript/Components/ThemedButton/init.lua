local Roact = require(script.Parent.Parent.Vendor.Roact)
local ThemeContext = require(script.Parent.ThemeContext)
local Typer = require(script.Parent.Parent.Vendor.Typer)

local ThemedButton = Roact.PureComponent:extend("ThemedButton")

ThemedButton.validateProps = Typer.MapDefinition({
	AnchorPoint = Typer.OptionalVector2,
	Position = Typer.OptionalUDim2,
	Size = Typer.UDim2,
	LayoutOrder = Typer.Integer,
	Font = Typer.EnumOfTypeFont,
	Text = Typer.String,
	SizeConstraint = Typer.OptionalEnumOfTypeSizeConstraint,
	ZIndex = Typer.OptionalNumber,
	TextSize = Typer.PositiveInteger,

	Disabled = Typer.Boolean,
	OnClicked = Typer.Function,
})

local Roact_createElement = Roact.createElement

function ThemedButton.getDerivedStateFromProps(props)
	return {
		modifier = props.Disabled and "Disabled" or "Default",
	}
end

function ThemedButton:init()
	self:setState({
		modifier = "Default",
	})

	self.inputBegan = function(_, inputObject: InputObject)
		print(self.state.modifier)
		if self.state.modifier == "Disabled" then
			return
		end

		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
			local onClicked = self.props.OnClicked
			if onClicked then
				onClicked(inputObject)
			end

			self:setState({
				modifier = "Pressed",
			})
		elseif inputObject.UserInputType == Enum.UserInputType.MouseMovement then
			if self.state.modifier ~= "Pressed" then
				self:setState({
					modifier = "Hover",
				})
			end
		end
	end

	self.inputEnded = function(_, inputObject: InputObject)
		if self.state.modifier == "Disabled" then
			return
		end

		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
			print("Resetting")
			self:setState({
				modifier = "Default",
			})
		--elseif inputObject.UserInputType == Enum.UserInputType.MouseMovement then
		--	self:setState({
		--		modifier = "Default",
		--	})
		end
	end
end

--Enum.StudioStyleGuideModifier.Default
--Enum.StudioStyleGuideModifier.Disabled
--Enum.StudioStyleGuideModifier.Hover
--Enum.StudioStyleGuideModifier.Pressed
--Enum.StudioStyleGuideModifier.Selected

function ThemedButton:render()
	return Roact_createElement(ThemeContext.Consumer, {
		render = function(theme)
			local props = self.props
			return Roact_createElement("TextButton", {
				AnchorPoint = props.AnchorPoint,
				AutoButtonColor = false,
				Position = props.Position,
				Size = props.Size,
				LayoutOrder = props.LayoutOrder,
				ZIndex = props.ZIndex,
				SizeConstraint = props.SizeConstraint,
				Text = "",
				BorderSizePixel = 0,
				BackgroundColor3 = theme.MainButton[self.state.modifier],

				[Roact.Event.InputBegan] = self.inputBegan,
				[Roact.Event.InputEnded] = self.inputEnded,
			}, {
			})
		end,
	})
end

return ThemedButton
