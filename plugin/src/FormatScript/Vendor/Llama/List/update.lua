local Debug = require(script.Parent.Parent.Parent.Debug)
local Typer = require(script.Parent.Parent.Parent.Typer)
local copy = require(script.Parent.copy)

local Debug_Assert = Debug.Assert

local function noUpdate(value)
	return value
end

local function call(callback, ...)
	if type(callback) == "function" then
		return callback(...)
	end
end

local function update(list, index, updater, callback)
	local len = #list
	if index < 0 then
		index = len + index
	end

	Debug_Assert(index > 0 and index <= len + 1, "index %d out of bounds of list of length %d", index, len)
	updater = updater or noUpdate
	local new = copy(list)

	if new[index] ~= nil then
		new[index] = updater(new[index], index)
	else
		new[index] = call(callback, index)
	end

	return new
end

return Typer.AssignSignature(Typer.Array, Typer.Integer, Typer.OptionalFunction, Typer.OptionalFunction, update)
