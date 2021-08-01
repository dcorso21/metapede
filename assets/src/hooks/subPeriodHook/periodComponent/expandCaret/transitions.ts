// @ts-check
import * as d3 from "d3";

function rotateOpen(selection) {
	selection
		.transition()
		.duration(500)
		.style("transform", "rotate(90deg)")
}

function rotateClose(selection) {
	selection
		.transition()
		.duration(500)
		.style("transform", "rotate(0deg)")
}

function fadeIn(selection) {
	selection
		.style("opacity", 0)
		.transition()
		.duration(200)
		.style("opacity", 1)
}

function fadeOut(selection) {
	selection
		.style("opacity", 1)
		.transition()
		.duration(200)
		.style("opacity", 0)
}

const expandCaretTransitions = { rotateOpen, rotateClose, fadeIn };

export default expandCaretTransitions;