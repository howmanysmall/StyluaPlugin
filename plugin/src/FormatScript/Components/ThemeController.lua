local GetTheme = require(script.Parent.Parent.Utility.GetTheme)
local Roact = require(script.Parent.Parent.Vendor.Roact)
local ThemeContext = require(script.Parent.ThemeContext)

local ThemeController = Roact.PureComponent:extend("ThemeController")

function ThemeController:init()
	self:setState({
		theme = GetTheme(),
	})
end

function ThemeController:didMount()
	self.connection = settings().Studio.ThemeChanged:Connect(function()
		self:setState({
			theme = GetTheme(),
		})
	end)
end

function ThemeController:willUnmount()
	self.connection:Disconnect()
end

function ThemeController:render()
	return Roact.createElement(ThemeContext.Provider, {
		value = self.state.theme,
	}, self.props[Roact.Children])
end

return ThemeController
