// @ts-check

function rotateOpen(selection:any) {
	selection
		.transition()
		.duration(500)
		.style("transform", "rotate(90deg)")
}

function rotateClose(selection:any) {
	selection
		.transition()
		.duration(500)
		.style("transform", "rotate(0deg)")
}

function fadeIn(selection:any) {
	selection
		.style("opacity", 0)
		.transition()
		.duration(200)
		.style("opacity", 1)
}

// function fadeOut(selection:any) {
// 	selection
// 		.style("opacity", 1)
// 		.transition()
// 		.duration(200)
// 		.style("opacity", 0)
// }

const expandCaretTransitions = { rotateOpen, rotateClose, fadeIn };

export default expandCaretTransitions;