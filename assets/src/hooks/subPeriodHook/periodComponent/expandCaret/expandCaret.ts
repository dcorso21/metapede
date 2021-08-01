// @ts-check
// import * as d3 from "d3";
import periodComponent from "../period";
import expandCaretTransitions from "./transitions";


function selectEl(period) {
	return periodComponent
		.selectEl(period.id)
		.select(".drop_caret")
}


function toggleTransition(period) {
	const transition = period.expand
		? expandCaretTransitions.rotateClose
		: expandCaretTransitions.rotateOpen;

	selectEl(period).call(transition)
}

function createEach(period) {
	if (period.has_sub_periods) {
		periodComponent.selectEl(period.id)
			.append("div")
			.attr("class", "drop_caret fas fa-chevron-right")
	}
}

const expandCaretComponent = { createEach, toggleTransition }

export default expandCaretComponent;