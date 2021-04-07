local Llama = require(script.Parent.Parent.Vendor.Llama)
local Roact = require(script.Parent.Parent.Vendor.Roact)

local Llama_Dictionary_join = Llama.Dictionary.join
local Roact_createElement = Roact.createElement

local function AutoFixedScrollingFrame(props)
	local count = 0
	for _ in next, props[Roact.Children] do
		count += 1
	end

	local rows = math.ceil(count / props.CellsPerRow)
	return Roact_createElement("ScrollingFrame", Llama_Dictionary_join(props.ScrollingFrame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromOffset(0, rows * props.CellSize.Y.Offset + rows * props.CellPadding.Y.Offset),
	}), Llama_Dictionary_join(props[Roact.Children], {
		UIGridLayout = Roact_createElement("UIGridLayout", Llama_Dictionary_join(props.GridLayout or {}, {
			CellPadding = props.CellPadding,
			CellSize = props.CellSize,
			FillDirectionMaxCells = props.CellsPerRow,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})),
	}))
end

return AutoFixedScrollingFrame