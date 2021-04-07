export interface StyluaStudioArguments {
	_: string[];
	p: number;
	port: number;

	h: boolean;
	help: boolean;

	path: string;
	files: string;
	config: string;
}

import { Application, Router } from "https://deno.land/x/oak/mod.ts";
import FormatController from "./Controllers/FormatController.ts";
import { ensureDir } from "https://deno.land/std@0.92.0/fs/mod.ts";
import { SEP as Separator } from "https://deno.land/std@0.92.0/path/mod.ts";
import { parse } from "https://deno.land/std@0.92.0/flags/mod.ts";
import GetOrSetEnv from "./Utility/GetOrSetEnv.ts";

import { red, bold } from "https://deno.land/std@0.92.0/fmt/colors.ts";
import { OPTIONS_STRING } from "./Constants.ts";

function main(args: string[]) {
	const home = Deno.env.get("HOME") || Deno.env.get("USERPROFILE");
	console.log(home);
	const formatterArguments = parse(args, {
		"--": false,
		default: {
			port: 62017,
			path: "stylua",
			files: `${home}${Separator}LuaFiles`,
			config: "",
		},

		alias: {
			"p": "port",
			"h": "help",
		},
	}) as StyluaStudioArguments;

	if (formatterArguments.help === true) console.log(OPTIONS_STRING);
	else if (!formatterArguments.files || !formatterArguments.path)
		console.log(`${red(bold("Error:"))} You are missing the ${bold("path")} or ${bold("files")} flag.\n${OPTIONS_STRING}`);
	else {
		const luaFiles = GetOrSetEnv("LuaFiles", formatterArguments.files);
		GetOrSetEnv("StyluaPath", formatterArguments.path);
		GetOrSetEnv("Config", formatterArguments.config)

		ensureDir(luaFiles).then(() => {
			const app = new Application();
			const appRouter = new Router();
			const port = 62017;

			appRouter
				.post("/formatLuau", FormatController.formatLuau)
				.get("/getTest", FormatController.getTest);

			app.use(appRouter.routes());
			app.use(appRouter.allowedMethods());

			app.addEventListener("listen", ({ secure, hostname, port }) => {
				const protocol = secure ? "https://" : "http://";
				const url = `${protocol}${hostname ?? "localhost"}:${port}`;
				console.log(`Listening on: ${url}`);
			})

			app.listen({ port }).catch(error => console.warn(`Failed to listen on port ${port}: ${error}`));
		}).catch(error => console.warn(`ensureDir(luaFiles) failed and returned error: ${error}`));
	}
}

main(Deno.args);