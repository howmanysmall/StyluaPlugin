--[[
	BasicState by csqrl (ClockworkSquirrel)
	Version: 0.2.0

	Other Contributors:
	https://github.com/ClockworkSquirrel/BasicState/graphs/contributors

	Documentation is at:
	https://clockworksquirrel.github.io/BasicState/

	Overview of Methods:
		BasicState.new([ InitialState: Dictionary<any, any> = {} ]): State

		State:Get(Key: any[, DefaultValue: any = nil]): any
		State:Set(Key: any, Value: any): void
		State:Delete(Key: any): void
		State:GetState(): Dictionary<any, any>
		State:SetState(StateTable: Dictionary<any, any>): void
		State:Toggle(Key: any): void
		State:Increment(Key: any[, Amount: Number = 1][, Cap: Number = nil]): void
		State:Decrement(Key: any[, Amount: Number = 1][, Cap: Number = nil]): void
		State:RawSet(Key: any, Value: any): void
		State:GetChangedSignal(Key: any): RBXScriptSignal
		State:Roact(Component: Roact.Component[, Keys: any[] = nil]): Roact.Component
		State:Destroy(): void

		State.Changed: RBXScriptSignal

		State.ProtectType: boolean
		State.None: Instance
--]]

local FastSignal = require(script.Parent.FastSignal)
local Janitor = require(script.Parent.Janitor)

local State = {
	None = newproxy(true);
}

State.__index = State
getmetatable(State.None).__tostring = function()
	return "BasicState.None"
end

function State.new(InitialState)
	local self = setmetatable({
		Changed = nil;
		ProtectType = false;

		Janitor = Janitor.new();
		State = type(InitialState) == "table" and InitialState or {};
		Signals = {};
	}, State)

	self.Changed = self.Janitor:Add(FastSignal.new(), "Destroy") --:AddMiddleware(FastSignal.LogMiddleware("BasicState.Changed:"))

	self.Janitor:Add(self.Changed:Connect(function(OldState, ChangedKey)
		local Signal = self.Signals[ChangedKey]

		if Signal then
			Signal:Fire(self:Get(ChangedKey), OldState[ChangedKey], OldState)
		end
	end), "Disconnect")

	return self
end

function State:__joinDictionary(...)
	local NewDictionary = {}

	for _, Dictionary in ipairs({...}) do
		if type(Dictionary) ~= "table" then
			continue
		end

		for Key, Value in next, Dictionary do
			if Value == State.None then
				continue
			end

			if self.ProtectType and NewDictionary[Key] and typeof(NewDictionary[Key]) ~= typeof(Value) then
				error(string.format("attempt to set %q to new value type %q. Disable State.ProtectType to allow this.", tostring(Key), typeof(Value)), 2)
			end

			if type(Value) == "table" then
				NewDictionary[Key] = self:__joinDictionary(NewDictionary[Key], Value)
				continue
			end

			NewDictionary[Key] = Value
		end
	end

	return NewDictionary
end

function State:GetState()
	return self:__joinDictionary(self.State)
end

function State:Rawset(Key, Value)
	self.State[Key] = Value
end

function State:Set(Key, Value)
	local OldState = self:GetState()

	if self.ProtectType then
		if OldState[Key] and typeof(Value) ~= typeof(OldState[Key]) then
			error(string.format("attempt to set %q to new value type %q. Disable State.ProtectType to allow this.", tostring(Key), typeof(Value)), 2)
		end
	end

	if type(Value) == "table" then
		Value = self:__joinDictionary(OldState[Key], Value)
	end

	if OldState[Key] ~= Value then
		self:Rawset(Key, Value)
		self.Changed:Fire(OldState, Key)
	end
end

function State:SetState(StateTable)
	assert(type(StateTable) == "table")

	for Key, Value in next, StateTable do
		self:Set(Key, Value)
	end
end

function State:Get(Key, DefaultValue)
	local StateValue = self:GetState()[Key]
	if StateValue == State.None then
		StateValue = nil
	end

	return StateValue == nil and DefaultValue or StateValue
end

function State:Delete(Key)
	return self:Set(Key, State.None)
end

function State:Toggle(Key)
	local Value = self:Get(Key)
	assert(type(Value) == "boolean")
	return self:Set(Key, not Value)
end

function State:Increment(Key, Amount, Cap)
	local Value = self:Get(Key)
	Amount = type(Amount) == "number" and Amount or 1
	assert(type(Value) == "number")

	local NewValue = Value + Amount

	if Cap then
		NewValue = math.min(NewValue, Cap)
	end

	return self:Set(Key, NewValue)
end

function State:Decrement(Key, Amount, Cap)
	local Value = self:Get(Key)
	Amount = type(Amount) == "number" and Amount or 1
	assert(type(Value) == "number")

	local NewValue = Value - Amount

	if Cap then
		NewValue = math.max(NewValue, Cap)
	end

	return self:Set(Key, NewValue)
end

function State:GetChangedSignal(Key)
	local Signal = self.Signals[Key]
	if Signal then
		return Signal
	end

	Signal = self.Janitor:Add(FastSignal.new(), "Destroy") --:AddMiddleware(FastSignal.LogMiddleware(Key .. ":"))
	self.Signals[Key] = Signal
	return Signal
end

function State:Destroy()
	self.Janitor:Destroy()
	table.clear(self)
	setmetatable(self, nil)
end

function State:WithRoact(Component, Keys)
	local ComponentLifecycle = {
		init = Component.init,
		willUnmount = Component.willUnmount,
	}

	Component.__bsIsUnmounting = false

	function Component.init(this, ...)
		if ComponentLifecycle.init then
			ComponentLifecycle.init(this, ...)
		end

		this.__basicStateBindings = {}

		local InitialState = {}

		if type(Keys) == "table" then
			for _, Key in next, Keys do
				InitialState[Key] = self:Get(Key)

				this.__basicStateBindings[Key] = self:GetChangedSignal(Key):Connect(function(NewValue)
					this:setState({
						[Key] = NewValue,
					})
				end)
			end
		else
			InitialState = self:GetState()

			this.__basicStateBindings[1] = self.Changed:Connect(function()
				if this.__bsIsUnmounting then
					return
				end

				this:setState(self:GetState())
			end)
		end

		this:setState(InitialState)
	end

	function Component.willUnmount(this, ...)
		this.__bsIsUnmounting = true

		if ComponentLifecycle.willUnmount then
			ComponentLifecycle.willUnmount(this, ...)
		end

		if this.__basicStateBindings then
			for _, Connection in next, this.__basicStateBindings do
				Connection:Disconnect()
			end

			this.__basicStateBindings = {}
		end
	end

	return Component
end

return State
