export default function GetOrSetEnv(Name: string, DefaultValue: string): string {
	let Value = Deno.env.get(Name);
	if (Value === undefined) {
		Value = DefaultValue;
		Deno.env.set(Name, Value);
	}

	return Value;
}