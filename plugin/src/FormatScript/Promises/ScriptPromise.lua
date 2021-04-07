local Promise = require(script.Parent.Parent.Vendor.Promise)
local Scheduler = require(script.Parent.Parent.Vendor.Scheduler)
local Types = require(script.Parent.Parent.Types)

local ScriptPromise = {}

type Promise<Value> = Types.Promise<Value>;
type LuaSourceContainer = Types.LuaSourceContainer

local Promise_new = Promise.new
local Promise_Retry = Promise.Retry
local Scheduler_Wait = Scheduler.Wait

local MAX_RETRIES = 50

local function GetSource(LuaSourceContainer: LuaSourceContainer): Promise<string>
	return Promise_new(function(Resolve, Reject)
		local Source = LuaSourceContainer.Source
		if not Source then
			Scheduler_Wait(0.05)
			Reject("Couldn't find source.")
		else
			Resolve(Source)
		end
	end)
end

function ScriptPromise.PromiseSource(LuaSourceContainer: LuaSourceContainer): Promise<string>
	return Promise_Retry(GetSource, MAX_RETRIES, LuaSourceContainer)
end

return ScriptPromise