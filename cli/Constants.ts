import { red, bold } from "https://deno.land/std@0.92.0/fmt/colors.ts";

export const COMMAND_TEMPLATE = "cmd /c {STYLUA_TYPE} C:\\Users\\Studi\\OneDrive\\Documents\\GitHub\\StyLuaHost\\Lua\\{FILE_NAME}.lua";
export const FILE_PATH = "C:\\Users\\Studi\\OneDrive\\Documents\\GitHub\\StyLuaHost\\Lua\\{FILE_NAME}.lua";

export const COMMAND_ARRAY = ["cmd", "/c"];
export const COMMAND_ENTRY = "{STYLUA_TYPE} --config-path C:\\Users\\Studi\\OneDrive\\Documents\\GitHub\\StyLuaHost\\Lua\\stylua.toml C:\\Users\\Studi\\OneDrive\\Documents\\GitHub\\StyLuaHost\\Lua\\{FILE_NAME}.lua";

export const OPTIONS_STRING = `
${bold("USAGE:")}
	styluahost [OPTIONS] [ARGUMENTS]

${bold("OPTIONS:")}
	--help                      This will show this message.
	--path <styluapath>         This sets the Stylua path, if it's not on your Windows path.
	--config <stylua-config>    This sets the path to the Stylua configuration file. Completely optional.

${bold("ARGUMENTS:")}
	--files <folder>            This sets the path to where the Lua files will be created and formatted. Yes, this is probably bad design.
`;

export const RELEASES_URL = "https://damp-breeze-6671.johnnymorganz.workers.dev/";
export const DO_NOT_USE = ` ${red(bold("CURRENTLY UNUSED"))}`;