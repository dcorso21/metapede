// @ts-check
import * as d3 from "d3";
import { periodHeight } from "./period";

function enterTransition(selection) {
	let dlyInd = 0;
	selection
		.style("opacity", "0")
		.transition()
		.duration(150)
		.ease(d3.easeElasticIn)
		.delay(() => 50 * dlyInd++)
		.style("height", () => periodHeight + "px")
		.style("border-color", "transparent")
		.style("width", (d) => d.width)
		.style("opacity", "1")
		.transition()
		.duration(150)
		.ease(d3.easeElasticIn)
		.style("color", "inherit")
		.transition()
		.duration(150)
		.style("border-color", "rgba(255, 255, 255, 0.15)")
}


function updateTransition(selection) {
	selection
		.style("width", (d) => d.width)
}

function exitTransition(selection) {
	selection
		.transition()
		.duration(30)
		.ease(d3.easeBackInOut)
		.style("color", "rgba(255, 255, 255, 0)")
		.transition()
		.duration(150)
		.ease(d3.easeBackInOut)
		.style("width", "0px")
		.style("height", "0px")
		.style("opacity", "0")
		.style("border-color", "transparent")
		.remove();
}


const periodTransitions = {
	enterTransition, updateTransition, exitTransition
}


export default periodTransitions