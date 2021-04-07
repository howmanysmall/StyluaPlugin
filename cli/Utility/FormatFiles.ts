import { COMMAND_ARRAY, COMMAND_ENTRY } from "../Constants.ts";
import { map } from "./Immutable.ts";
import DetermineStyluaType from "./DetermineStyluaType.ts";
import { SEP as Separator } from "https://deno.land/std@0.92.0/path/mod.ts";

const filePathsCache = new Array<string>();

function cacheFileName(luaFilePath: string, fileIndex: number) {
	let filePath = filePathsCache[fileIndex];
	if (filePath !== undefined) return filePath;
	else {
		filePath = `{LUA_FILES}${Separator}{FILE_NAME}.lua`
			.replace("{FILE_NAME}", fileIndex.toString())
			.replace("{LUA_FILES}", luaFilePath);

		filePathsCache[fileIndex] = filePath;
		return filePath;
	}
}

export function PromiseFormatFiles(sourceCode: Array<string>) {
	return Promise.all(map<string, Promise<void>>(sourceCode, (fileSource, index) => {
		return Deno.writeTextFile(cacheFileName("", index), fileSource);
	})).then(() => {
		return Promise.all(map<string, Promise<Deno.ProcessStatus>>(sourceCode, (fileSource, index) => {
			return Deno.run({
				cmd: COMMAND_ARRAY.concat(COMMAND_ENTRY.replace("{STYLUA_TYPE}", DetermineStyluaType(fileSource)).replace("{FILE_NAME}", index.toString())),
				stderr: "null",
				stdout: "null",
			}).status();
		})).then((processStatuses) => {
			return Promise.all(map<Deno.ProcessStatus, Promise<string>>(processStatuses, (processStatus, index) => {
				if (!processStatus.success) console.warn(`Stylua failed to format the file at array index ${index} (code: ${processStatus.code}).`);
				return Deno.readTextFile(cacheFileName("", index));
			})).then((formattedSource) => {
				const removePromises = new Array<Promise<void>>(formattedSource.length);
				for (let index = 0; index < formattedSource.length; index += 1)
					removePromises[index] = Deno.remove(cacheFileName("", index));

				return Promise.all(removePromises).then(() => {
					return formattedSource;
				}).catch((error) => {
					console.warn(`Promise.all(removePromises) failed and returned the following error: ${error}`);
					return formattedSource;
				});
			});
		});
	});
}

const COMMAND_ENTRY_FORMATS: Map<boolean, string> = new Map<boolean, string>([
	[true, `{STYLUA_TYPE} {LUA_FILES}${Separator}{FILE_NAME}.lua`],
	[false, `{STYLUA_TYPE} --config-path {CONFIG_PATH} {LUA_FILES}${Separator}{FILE_NAME}.lua`],
]);

export default async function FormatFiles(sourceCode: Array<string>) {
	const styluaPath = Deno.env.get("StyluaPath") as string;
	const luaFiles = Deno.env.get("LuaFiles") as string;
	const config = Deno.env.get("Config") as string;
	// DetermineStyluaType(fileSource)

	const configIsNull = config === "";
	const commandEntry = COMMAND_ENTRY_FORMATS.get(configIsNull) as string;

	for (const [index, fileSource] of sourceCode.entries())
		Deno.writeTextFileSync(cacheFileName(luaFiles, index), fileSource);

	if (configIsNull) {
		const processStatuses = await Promise.all(map<string, Promise<Deno.ProcessStatus>>(sourceCode, (_, index) => {
			return Deno.run({
				cmd: COMMAND_ARRAY.concat(commandEntry
					.replace("{STYLUA_TYPE}", styluaPath)
					.replace("{LUA_FILES}", luaFiles)
					.replace("{FILE_NAME}", index.toString())
				),

				stderr: "null",
				stdout: "null",
			}).status();
		}));

		const formattedSource = map<Deno.ProcessStatus, string>(processStatuses, (processStatus, index) => {
			if (!processStatus.success) console.warn(`Stylua failed to format the file at array index ${index} (code: ${processStatus.code}).`);
			return Deno.readTextFileSync(cacheFileName(luaFiles, index));
		});

		for (let index = 0; index < formattedSource.length; index += 1) Deno.removeSync(cacheFileName(luaFiles, index));
		return formattedSource;
	} else {

		const processStatuses = await Promise.all(map<string, Promise<Deno.ProcessStatus>>(sourceCode, (_, index) => {
			return Deno.run({
				cmd: COMMAND_ARRAY.concat(commandEntry
					.replace("{STYLUA_TYPE}", styluaPath)
					.replace("{LUA_FILES}", luaFiles)
					.replace("{CONFIG_PATH}", config)
					.replace("{FILE_NAME}", index.toString())
				),

				stderr: "null",
				stdout: "null",
			}).status();
		}));

		const formattedSource = map<Deno.ProcessStatus, string>(processStatuses, (processStatus, index) => {
			if (!processStatus.success) console.warn(`Stylua failed to format the file at array index ${index} (code: ${processStatus.code}).`);
			return Deno.readTextFileSync(cacheFileName(luaFiles, index));
		});

		for (let index = 0; index < formattedSource.length; index += 1) Deno.removeSync(cacheFileName(luaFiles, index));
		return formattedSource;
	}
}

/*
.catch((error) => {
		console.warn(`Promise.all() failed and returned the following error: ${error}`);
		return sourceCode;
	});
*/