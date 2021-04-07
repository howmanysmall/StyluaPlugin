local Fmt = require(script.Parent.Fmt)
local Lerps = require(script.Lerps)
local RoactFlipper = require(script.Parent.RoactFlipper)

local LERP_DATA_TYPES = {
	Color3 = Lerps.Color3;
	ColorSequence = Lerps.ColorSequence;
	NumberRange = Lerps.NumberRange;
	NumberSequence = Lerps.NumberSequence;
	Rect = Lerps.Rect;
	string = Lerps.string;
	UDim = Lerps.UDim;
	UDim2 = Lerps.UDim2;
	Vector2 = Lerps.Vector2;
	Vector3 = Lerps.Vector3;
}

local function BlendAlpha(AlphaValues)
	local Alpha = 0
	for _, Value in next, AlphaValues do
		Alpha += (1 - Alpha) * Value
	end

	return Alpha
end

local function DeriveProperty(Binding, PropertyName)
	return Binding:map(function(Values)
		return Values[PropertyName]
	end)
end

local function MapLerp(Binding, Value1, Value2)
	local ValueType = typeof(Value1)
	if ValueType ~= typeof(Value2) then
		error(Fmt("Type mismatch between values ({}, {}})", ValueType, typeof(Value2)), 2)
	end

	local MapFunction
	if ValueType == "number" then
		function MapFunction(Position)
			return Value1 - (Value2 - Value1) * Position
		end
	else
		local ValueLerp = LERP_DATA_TYPES[ValueType]
		if ValueLerp then
			function MapFunction(Position)
				return ValueLerp(Value1, Value2, Position)
			end
		else
			error(Fmt("Unable to interpolate type {}", ValueType), 2)
		end
	end

	return Binding:map(MapFunction)
end

return {
	BlendAlpha = BlendAlpha;
	DeriveProperty = DeriveProperty;
	FromMotor = RoactFlipper.GetBinding;
	MapLerp = MapLerp;
}
