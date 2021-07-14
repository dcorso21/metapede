// @ts-check

import * as d3 from "d3";
import HoverInfo from "./periodComponent/hoverInfo/hoverInfo";
import { enterPeriod, updatePeriod, exitPeriod, periodHeight } from "./periodComponent/period";
import subPeriodTransforms from "./transforms";
import { setHeightTransition } from "./transitions";
// import moment from "moment";


// @ts-ignore
global.subPeriodsConn; 

function renderSubPeriods(conn) {
	const phxElement = conn.el;
	let sub_periods = JSON.parse(phxElement.dataset.sub_periods);
	sub_periods = subPeriodTransforms.transform(sub_periods);


	d3.select(phxElement)
		.call((select) => setHeightTransition(select, sub_periods.length * periodHeight))
		.selectAll(".sub_period")
		.data(sub_periods, (d) => d.id)
		.join(
			enterPeriod,
			updatePeriod,
			exitPeriod
		);
}


function mounted() {
	HoverInfo.createBlank()
	// @ts-ignore
	global.subPeriodsConn = this;
	renderSubPeriods(this);
}

function updated() {
	// @ts-ignore
	global.subPeriodsConn = this;
	renderSubPeriods(this);
}

// @ts-ignore
// function handleClickName(tp) {
// 	// @ts-ignore
// 	global.subPeriodsConn.pushEvent("redirect_to_sub_period", tp.id);
// }


const subPeriodHook = {
	mounted,
	updated
}


export default subPeriodHook;