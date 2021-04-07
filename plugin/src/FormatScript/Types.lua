local Promise = require(script.Parent.Vendor.Promise)

export type Array<Value> = {Value}
export type Dictionary<Value> = {[string]: Value}

export type Promise<Value> = typeof(Promise.new())
export type LuaSourceContainer = Script | LocalScript | ModuleScript
export type Headers = Dictionary<string>

export type RequestDictionary = {
	Url: string,
	Body: string?,
	Method: string?,
	Headers: Headers?,
}

export type ResponseDictionary = {
	Headers: Headers,
	Success: boolean,
	StatusCode: number,
	StatusMessage: string,
	Body: string,
}

export type CatchFunction = (string) -> nil

return false