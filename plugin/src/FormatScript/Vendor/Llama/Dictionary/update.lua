local Typer = require(script.Parent.Parent.Parent.Typer)
local copy = require(script.Parent.copy)

local function noUpdate(value)
	return value
end

local function call(callback, ...)
	if type(callback) == "function" then
		return callback(...)
	end
end

local function update(dictionary, key, updater, callback)
	updater = updater or noUpdate
	local new = copy(dictionary)

	if new[key] ~= nil then
		new[key] = updater(new[key], key)
	else
		new[key] = call(callback, key)
	end

	return new
end

return Typer.AssignSignature(Typer.Table, Typer.Any, Typer.OptionalFunction, Typer.OptionalFunction, update)
