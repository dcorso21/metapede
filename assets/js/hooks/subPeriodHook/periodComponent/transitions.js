// @ts-check
import * as d3 from "d3";
import { periodHeight } from "./period";

function enterTransition(selection) {
	let dlyInd = 0;
	selection
		.transition()
		.duration(150)
		.ease(d3.easeElasticIn)
		.delay(() => 50 * dlyInd++)
		.style("width", (d) => d.width)
		.style("height", () => periodHeight + "px")
		.transition()
		.duration(150)
		.ease(d3.easeElasticIn)
		.style("color", "inherit")
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
		.remove();
}


const periodTransitions = {
	enterTransition, updateTransition, exitTransition
}


export default periodTransitions