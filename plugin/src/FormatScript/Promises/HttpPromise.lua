local HttpService = game:GetService("HttpService")
local Promise = require(script.Parent.Parent.Vendor.Promise)
local Types = require(script.Parent.Parent.Types)

local HttpPromise = {}

local Promise_Defer = Promise.Defer
local Promise_new = Promise.new
local Promise_Reject = Promise.Reject
local Promise_Resolve = Promise.Resolve

type Promise<Value> = Types.Promise<Value>;
type RequestDictionary = Types.RequestDictionary
type ResponseDictionary = Types.ResponseDictionary
type Headers = Types.Headers

local function RequestAsync(RequestDictionary: RequestDictionary): ResponseDictionary
	return HttpService:RequestAsync(RequestDictionary)
end

local function JsonDecode(JsonString: string): any
	return HttpService:JSONDecode(JsonString)
end

local function PostAsync(Url: string, Data: string, HttpContentType: Enum.HttpContentType?, Compress: boolean?, Headers: Headers?)
	return HttpService:PostAsync(Url, Data, HttpContentType, Compress, Headers)
end

local function JsonEncode(Data: any): string
	return HttpService:JSONEncode(Data)
end

local function ReturnBody(ResponseDictionary: ResponseDictionary): string
	return ResponseDictionary.Body
end

function HttpPromise.PromiseRequest(RequestDictionary: RequestDictionary): Promise<ResponseDictionary>
	return Promise_Defer(function(Resolve, Reject)
		local Success, Value = pcall(RequestAsync, RequestDictionary)
		if Success then
			if not Value.Success then
				Reject(string.format("HTTP %d: %s", Value.StatusCode, Value.StatusMessage))
			else
				Resolve(Value)
			end
		else
			Reject(Value)
		end
	end)
end

function HttpPromise.PromiseDecodeResponse(ResponseDictionary: ResponseDictionary): string
	local Body = ResponseDictionary.Body
	if type(Body) ~= "string" then
		return Promise_Reject(string.format("Body is not of type string, but says %s", tostring(Body)))
	end

	return Promise_new(function(Resolve, Reject)
		local Success, Value = pcall(JsonDecode, Body)
		if not Success then
			Reject(Value)
		elseif Value then
			Resolve(Success)
		else
			Reject("Decoded nothing.")
		end
	end)
end

type FailedRequest = string | ResponseDictionary

function HttpPromise.LogFailedRequests(...: FailedRequest)
	for _, Item in ipairs({...}) do
		if type(Item) == "string" then
			warn(Item)
		elseif type(Item) == "table" and type(Item.StatusCode) == "number" then
			warn(string.format("Failed request %d %q", Item.StatusCode, tostring(Item.Body)))
		end
	end
end

local HttpPromise_PromiseRequest = HttpPromise.PromiseRequest

function HttpPromise.PromiseGet(Url: string, NoCache: boolean?, UseHeaders: Headers?): Promise<string>
	local Headers = UseHeaders or {}
	if NoCache then
		Headers["Cache-Control"] = "no-cache"
	end

	local RequestDictionary = {
		Headers = Headers;
		Method = "GET";
		Url = Url;
	}

	return HttpPromise_PromiseRequest(RequestDictionary):Then(ReturnBody)
end

function HttpPromise.PromisePost(Url: string, Data: string, HttpContentType: Enum.HttpContentType?, Compress: boolean?, UseHeaders: Headers?): Promise<string>
	local Headers = UseHeaders or {}
	HttpContentType = HttpContentType or Enum.HttpContentType.ApplicationJson
	Compress = Compress == nil and false or Compress

	if Compress then
		return Promise_Defer(function(Resolve, Reject)
			local Success, Value = pcall(PostAsync, Url, Data, HttpContentType, Compress, Headers);
			(Success and Resolve or Reject)(Value)
		end)
	else
		if HttpContentType == Enum.HttpContentType.ApplicationJson then
			Headers["content-type"] = "application/json"
		elseif HttpContentType == Enum.HttpContentType.ApplicationUrlEncoded then
			Headers["content-type"] = "application/x-www-form-urlencoded"
		elseif HttpContentType == Enum.HttpContentType.ApplicationXml then
			Headers["content-type"] = "application/xml"
		elseif HttpContentType == Enum.HttpContentType.TextPlain then
			Headers["content-type"] = "text/plain"
		elseif HttpContentType == Enum.HttpContentType.TextXml then
			Headers["content-type"] = "text/xml"
		end

		local RequestDictionary = {
			Body = Data;
			Headers = Headers;
			Method = "POST";
			Url = Url;
		}

		return HttpPromise_PromiseRequest(RequestDictionary):Then(ReturnBody)
	end
end

function HttpPromise.PromiseJson(Data: any): Promise<string>
	return Promise_new(function(Resolve, Reject)
		local Success, Value = pcall(JsonEncode, Data);
		(Success and Resolve or Reject)(Value)
	end)
end

function HttpPromise.PromiseDecode(JsonString: string): Promise<any>
	return Promise_new(function(Resolve, Reject)
		local Success, Value = pcall(JsonDecode, JsonString);
		(Success and Resolve or Reject)(Value)
	end)
end

function HttpPromise.PromiseUrlEncode(String: string): Promise<string>
	return Promise_Resolve(HttpService:UrlEncode(String))
end

return HttpPromise
