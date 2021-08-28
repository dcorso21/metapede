import { TimePeriod } from "../../types";
import periodComponent from "../period";
import expandCaretTransitions from "./transitions";


function selectEl(period:TimePeriod) {
	return periodComponent
		.selectEl(period._id)
		.select(".drop_caret")
}


function toggleTransition(period:TimePeriod) {
	const transition = period.expand
		? expandCaretTransitions.rotateClose
		: expandCaretTransitions.rotateOpen;

	selectEl(period).call(transition)
}

function createEach(period:TimePeriod) {
	if (period.has_sub_periods) {
		periodComponent.selectEl(period._id)
			.append("div")
			.attr("class", "drop_caret fas fa-chevron-right")
	}
}

const expandCaretComponent = { createEach, toggleTransition }

export default expandCaretComponent;