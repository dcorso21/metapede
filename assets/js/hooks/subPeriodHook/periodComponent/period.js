// @ts-check
import * as d3 from "d3";
import periodTransitions from "./transitions";
import addAllPeriodEventListeners from "./eventHandlers";

export const periodHeight = 30;


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
}

export function updatePeriod(update) {
	// let delayInd = -1;
	return update.call((update) => {
		update
			.style("top", (_, i) => i * periodHeight + "px")
			.style("width", (d) => d.width)
			.style("left", (d) => d.ml)
			.each(createExpandEl)
			.call(periodTransitions.updateTransition)
	});
}

function createExpandEl(period, _index) {
	if (period.expand && period.sub_time_periods > 1) {
		d3.select(`#sub_per_exp_${period.id}`)
			.remove();

		d3.select(`#sub_per_${period.id}`)
			.append("div")
			.attr("id", `sub_per_exp_${period.id}`)
			.attr("class", "per_expansion")
			.style("height", periodHeight * period.sub_time_periods + "px")
			// .style("position", "absolute")
			// .style("top", "0px")
			// .style("left", "0px")
			// .style("width", "100%")
			// .style("background-color", "white")

	} else {
		d3.select(`#sub_per_exp_${period.id}`)
			.remove();
	}
}

export function exitPeriod(exit) {
	// let delayInd = -1;
	return exit.call(periodTransitions.exitTransition)
}
