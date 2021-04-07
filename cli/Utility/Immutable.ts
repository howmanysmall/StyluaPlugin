type MapFunction<K, V> = (value: K, index: number) => V | undefined;
type FilterFunction<K> = (value: K, index: number) => boolean | undefined;

function ipairs<K>(array: Array<K>) {
	return array.entries();
}

export function map<K, V>(array: Array<K>, callback: MapFunction<K, V>) {
	const newArray = new Array<V>();
	let length = -1;

	for (const [index, value] of ipairs(array)) {
		const newValue = callback(value, index);
		if (newValue !== undefined) {
			length += 1;
			newArray[length] = newValue;
		}
	}

	return newArray;
}

export function mapPromise<K, V>(array: Array<K>, callback: MapFunction<K, Promise<V>>) {
	const newArray = new Array<V>();
	let length = -1;

	for (const [index, value] of ipairs(array)) {
		callback(value, index)?.then((newValue) => {
			if (newValue !== undefined) {
				length += 1;
				newArray[length] = newValue;
			}
		});
	}

	return newArray;
}

export function filter<K>(array: Array<K>, callback: FilterFunction<K>) {
	const newArray = new Array<K>();
	let length = -1;

	for (const [index, value] of ipairs(array))
		if (callback(value, index)) {
			length += 1;
			newArray[length] = value;
		}

	return newArray;
}