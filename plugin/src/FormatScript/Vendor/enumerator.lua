-- enumerations in pure Luau
-- @docs https://roblox.github.io/enumerate/
-- documented changed functions

local Typer = require(script.Parent.Typer)

local ALREADY_USED_NAME_ERROR = "Already used %q as a value name in enum %q."
local ALREADY_USED_VALUE_ERROR = "Already used %q as a value in enum %q."
local INVALID_MEMBER_ERROR = "%q (%s) is not a valid member of %s"
local INVALID_VALUE_ERROR = "Couldn't cast value %q (%s) to enumerator %q"

local function lockTable(tab, name)
	name = name or tostring(tab)

	local function protectedFunction(_, key)
		error(string.format(
			INVALID_MEMBER_ERROR,
			tostring(key),
			typeof(key),
			tostring(name)
		))
	end

	return setmetatable(tab, {
		__index = protectedFunction,
		__newindex = protectedFunction,
	})
end

--[[**
	Creates a new enumeration.
	@param [t:string] enumName The unique name of the enumeration.
	@param [t:union(t:array<t:string>, t:keys<t:string>)] enumValues The values of the enumeration.
	@returns [t:userdata] a new enumeration
**--]]
local enumerator = Typer.AssignSignature(Typer.String, Typer.ArrayOfStringsOrDictionary, function(enumName, enumValues)
	local enum = newproxy(true)
	local metatable = getmetatable(enum)

	local internal = {}
	local rawValues = {}

	function metatable.__tostring()
		return enumName
	end

	function internal.FromRawValue(rawValue)
		return rawValues[rawValue]
	end

	function internal.IsEnumValue(value)
		if typeof(value) ~= "userdata" then
			return false
		end

		for _, enumValue in pairs(internal) do
			if enumValue == value then
				return true
			end
		end

		return false
	end

	function internal.Cast(value)
		if internal.IsEnumValue(value) then
			return value
		end

		local foundEnumerator = internal.FromRawValue(value)
		if foundEnumerator ~= nil then
			return foundEnumerator
		else
			return false, string.format(
				INVALID_VALUE_ERROR,
				tostring(value),
				typeof(value),
				tostring(enum)
			)
		end
	end

	if enumValues[1] then
		for _, valueName in ipairs(enumValues) do
			assert(valueName ~= "FromRawValue", "Cannot use 'FromRawValue' as a value")
			assert(valueName ~= "IsEnumValue", "Cannot use 'IsEnumValue' as a value")
			assert(internal[valueName] == nil, string.format(ALREADY_USED_NAME_ERROR, valueName, enumName))
			assert(rawValues[valueName] == nil, string.format(ALREADY_USED_VALUE_ERROR, valueName, enumName))

			local value = newproxy(true)
			local metatable = getmetatable(value)
			local valueString = string.format("%s.%s", enumName, valueName)

			function metatable.__tostring()
				return valueString
			end

			metatable.__index = lockTable({
				Name = valueName,
				Value = valueName,
				RawName = function()
					return valueName
				end,

				RawValue = function()
					return valueName
				end,
			})

			internal[valueName] = value
			rawValues[valueName] = value
		end
	else
		for valueName, rawValue in pairs(enumValues) do
			assert(valueName ~= "FromRawValue", "Cannot use 'FromRawValue' as a value")
			assert(valueName ~= "IsEnumValue", "Cannot use 'IsEnumValue' as a value")
			assert(internal[valueName] == nil, string.format(ALREADY_USED_NAME_ERROR, valueName, enumName))
			assert(rawValues[valueName] == nil, string.format(ALREADY_USED_VALUE_ERROR, valueName, enumName))

			local value = newproxy(true)
			local metatable = getmetatable(value)
			local valueString = string.format("%s.%s", enumName, valueName)

			function metatable.__tostring()
				return valueString
			end

			metatable.__index = lockTable({
				Name = valueName,
				Value = rawValue,
				RawName = function()
					return valueName
				end,

				RawValue = function()
					return rawValue
				end,
			})

			internal[valueName] = value
			rawValues[rawValue] = value
		end
	end

	metatable.__index = lockTable(internal, enumName)
	return enum
end)

return enumerator