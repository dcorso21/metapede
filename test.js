

let ar = [10, 20, 30, 40, 50]

function findNextOfSameDepth(arr, depth, index) {
	let rest = arr.slice(index + 1)
	console.log(rest);
	let next = rest.indexOf(depth)
	if (next < 0) return rest.length;
	return next;
}

console.log(
	findNextOfSameDepth(ar, 30, 0)
);