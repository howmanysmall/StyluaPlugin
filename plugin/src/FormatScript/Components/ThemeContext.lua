local GetTheme = require(script.Parent.Parent.Utility.GetTheme)
local Roact = require(script.Parent.Parent.Vendor.Roact)

local ThemeContext = Roact.createContext(GetTheme())

return ThemeContext
