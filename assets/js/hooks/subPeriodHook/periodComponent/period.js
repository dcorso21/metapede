// @ts-check
import * as d3 from "d3";
import periodTransitions from "./transitions";
import addAllPeriodEventListeners from "./eventHandlers";
import expandComponent from "./expandElement/expandElement";

export const periodHeight = 30;

export function selectEl(periodId) {
	return d3.select(`#sub_per_${periodId}`)
}

export function enterPeriod(enter) {
	return enter
		.append("div")
		.call(selection => addAllPeriodEventListeners(selection))
		.attr("class", "sub_period")
		.attr("id", (d) => "sub_per_" + d.id)
		.style("left", (d) => d.ml)
		.style("top", (_, i) => periodHeight * i + "px")
		.style("height", () => "0px")
		.style("width", (d) => "0px")
		.text((d) => d.topic.title)
		.style("color", "rgba(255, 255, 255, 0.0)")
		.call(periodTransitions.enterTransition)
		.each(d => {
			if (d.has_sub_periods) {
				selectEl(d.id)
					.append("div")
					.attr("class", "drop_caret fas fa-chevron-right")
			}
		})
}

export function updatePeriod(update) {
	// let delayInd = -1;
	return update.call((update) => {
		update
			.style("top", (_, i) => i * periodHeight + "px")
			.style("width", (d) => d.width)
			.style("left", (d) => d.ml)
			.each(expandComponent.update)
			.call(periodTransitions.updateTransition)
	});
}

export function exitPeriod(exit) {
	// let delayInd = -1;
	return exit.call(periodTransitions.exitTransition)
}

const periodComponent = {
	enterPeriod, updatePeriod, exitPeriod, selectEl
}

export default periodComponent;