// @ts-check
import * as d3 from "d3";
import periodTransitions from "./transitions";
import addAllPeriodEventListeners from "./eventHandlers";


export const periodHeight = 30;
// import moment from "moment";


export function enterPeriod(enter) {
	return enter
		.append("div")
		.call(selection => addAllPeriodEventListeners(selection))
		.attr("class", "sub_period")
		.style("left", (d) => d.ml)
		.style("top", (_, i) => periodHeight * i + "px")
		.style("height", () => "0px")
		.style("width", (d) => "0px")
		.text((d) => d.topic.title)
		.style("color", "rgba(255, 255, 255, 0.0)")
		.call(periodTransitions.enterTransition)
}

export function updatePeriod(update) {
	// let delayInd = -1;
	return update.call((update) => {
		update
			.style("top", (_, i) => i * periodHeight + "px")
			.style("width", (d) => d.width)
			.style("left", (d) => d.ml)
			.call(periodTransitions.updateTransition)
	});
}

export function exitPeriod(exit) {
	// let delayInd = -1;
	return exit.call(periodTransitions.exitTransition)
}
