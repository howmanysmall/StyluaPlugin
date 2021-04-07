import { Request, Response } from "https://deno.land/x/oak/mod.ts";
import FormatFiles from "../Utility/FormatFiles.ts";

type PostParameters = { request: Request, response: Response }
type GetParameters = { response: Response }

export default {
	/**
	 * @description Handles the POST request for formatting.
	 * @route POST /formatLuau
	 */
	formatLuau: async ({ request, response }: PostParameters) => {
		const body = await request.body();
		if (!request.hasBody) {
			response.status = 400;
			response.body = {
				Success: false,
				Message: "No data provided",
			};
		} else {
			// console.log(`body.type: ${body.type}`);
			if (body.type === "json") {
				const value = await body.value;
				const Data = await FormatFiles(value);
				response.body = {
					Success: true,
					Data,
				};

				// body.value.then((value: Array<string>) => {
				// 	const files = FormatFiles(value);
				// 	FormatFiles(value).then((data) => {
				// 		response.body = {
				// 			success: true,
				// 			data,
				// 		};
				// 	}).catch((error) => {
				// 		console.warn(`FormatFiles failed and returned error: ${error}`);
				// 	});
				// }).catch((error) => {
				// 	console.warn(`body.value failed and returned error: ${error}`);
				// });
			} else
				response.body = {
					Success: false,
					Message: "Did not get Json in POST.",
				};
		}
	},

	/**
	 * @description Handles a GET request.
	 * @route GET /getTest
	 */
	getTest: ({ response }: GetParameters) => {
		response.body = {
			success: true,
			message: "Hello, noob!",
		};
	},
}