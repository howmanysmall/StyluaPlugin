local AssignedBinding = require(script.AssignedBinding)
local Flipper = require(script.Parent.Flipper)
local Roact = require(script.Parent.Roact)

local RoactFlipper = {}

function RoactFlipper.GetBinding(Motor)
	local IsMotor = Flipper.IsMotor(assert(Motor, "Missing argument #1: motor"))
	if not IsMotor then
		error("Provided value is not a motor!", 2)
	end

	if Motor[AssignedBinding] then
		return Motor[AssignedBinding]
	end

	local Binding, SetBindingValue = Roact.createBinding(Motor:GetValue())
	Motor:OnStep(SetBindingValue)

	Motor[AssignedBinding] = Binding
	return Binding
end

return RoactFlipper
