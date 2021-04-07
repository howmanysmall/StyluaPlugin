local Selection = game:GetService("Selection")
local CatchFactory = require(script.Parent.Promises.CatchFactory)
local ChunkString = require(script.Parent.Utility.ChunkString)
local HttpPromise = require(script.Parent.Promises.HttpPromise)
local Janitor = require(script.Parent.Vendor.Janitor)
local Promise = require(script.Parent.Vendor.Promise)
local Llama = require(script.Parent.Vendor.Llama)
local ScriptPromise = require(script.Parent.Promises.ScriptPromise)
local Types = require(script.Parent.Types)

local HttpPromise_PromiseDecode = HttpPromise.PromiseDecode
local HttpPromise_PromiseJson = HttpPromise.PromiseJson
local HttpPromise_PromisePost = HttpPromise.PromisePost
local ScriptPromise_PromiseSource = ScriptPromise.PromiseSource
local Promise_All = Promise.All

local Llama_List_filter = Llama.List.filter
local Llama_List_map = Llama.List.map

type Array<Value> = Types.Array<Value>;
type Promise<Value> = Types.Promise<Value>;
type LuaSourceContainer = Types.LuaSourceContainer

local PluginJanitor = Janitor.new()

local function Unloading()
	print("Unloading.")
	PluginJanitor:Destroy()
end

local function MapFunction(LuaSourceContainer)
	if LuaSourceContainer:IsA("LuaSourceContainer") then
		return ScriptPromise_PromiseSource(LuaSourceContainer)
	end
end

local function EveryFunction(LuaSourceContainer: LuaSourceContainer)
	if not LuaSourceContainer:IsA("LuaSourceContainer") then
		Selection:Remove(table.create(1, LuaSourceContainer))
	end
end

local function FilterFunction(LuaSourceContainer: LuaSourceContainer)
	return LuaSourceContainer:IsA("LuaSourceContainer")
end

local function FormatScripts(Scripts: Array<LuaSourceContainer>): Promise<Array<string>>
	for _, Object in ipairs(Scripts) do
		if Object:IsA("LuaSourceContainer") then
			continue
		end

		Selection:Remove(table.create(1, Object))
	end

	local FilteredArray = Llama_List_filter(Scripts, FilterFunction)
	return PluginJanitor:AddPromise(Promise_All(Llama_List_map(FilteredArray, MapFunction))):Then(HttpPromise_PromiseJson):Then(function(JsonString: string)
		return PluginJanitor:AddPromise(HttpPromise_PromisePost("http://localhost:62017/formatLuau", JsonString, Enum.HttpContentType.ApplicationJson)):Then(HttpPromise_PromiseDecode):Then(function(ResponseTable)
			if ResponseTable.Success then
				for Index, ScriptSource in ipairs(ResponseTable.Data) do
					local ParentScript = FilteredArray[Index]
					if not ParentScript or not ParentScript:IsDescendantOf(game) then
						warn("Something happened to script at index", Index)
						continue
					end

					if utf8.len(ScriptSource) > 195_000 then
						warn("Script", ParentScript.Name, "is too long, splitting it up.")

						for ScriptIndex, SplitSource in ChunkString(ScriptSource, 195_000) do
							local NewScript = Instance.new("ModuleScript")
							NewScript.Name = ParentScript.Name .. ScriptIndex
							NewScript.Source = SplitSource
							NewScript.Parent = ParentScript
						end
					else
						ParentScript.Source = ScriptSource
					end
				end
			else
				warn(ResponseTable.Message)
			end
		end)
	end)
end

local function FormatSelection()
	return FormatScripts(Selection:Get()):Catch(CatchFactory("FormatScripts(Selection:Get())"))
end

_G.FormatScripts = FormatSelection
_G.FormatSelection = FormatSelection
PluginJanitor:Add(plugin.Unloading:Connect(Unloading), "Disconnect")