export default function DetermineStyluaType(source: string) {
	if (
		source.includes("createElement") ||
		source.includes("createContext") ||
		source.includes("oneChild") ||
		source.includes("createBinding") ||
		source.includes("createFragment")
	) return "stylua2Roact";
	else return "stylua2";
}