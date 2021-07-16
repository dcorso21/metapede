// @ts-check

// import * as d3 from "d3";
import { getSubPeriodsConn } from "../../subPeriodHook";
import HoverInfoElement from "./hoverInfo";
import { hoverInfoFadeIn, hoverInfoFadeOut } from "./transitions";


function handleMouseOver(e, per) {
	const hoverInfo = HoverInfoElement.selectEl()
	HoverInfoElement.updateInfo(hoverInfo, per)
	let { x, y, width } = e.target.getBoundingClientRect()
	// @ts-ignore
	const hoverBox = hoverInfo.node().getBoundingClientRect()
	const left = x + (width / 2) - (hoverBox.width / 2)
	const top = y - hoverBox.height + window.scrollY;

	hoverInfo
		.style("left", left + "px")
		.style("top", top + "px")
		.call(hoverInfoFadeIn)
}


function handleMouseOut(e, per) {
	if (isHoverElement(e)) return;
	HoverInfoElement
		.selectEl()
		.call(hoverInfoFadeOut)
}


function isHoverElement(e) {
	const hoverInfo = HoverInfoElement.selectEl()
	// @ts-ignore
	const elementIsInside = hoverInfo.node().contains(e.toElement);
	const isHoverInfo = hoverInfo.node() == e.toElement;
	console.log({ elementIsInside, isHoverInfo, toEl: e.toElement });
	return elementIsInside || isHoverInfo;
}


function handleClick(period) {
	HoverInfoElement.selectEl().style("opacity", "0")
	getSubPeriodsConn().pushEvent("redirect_to_sub_period", period.id);
}

const periodHoverElementEventHandlers = {
	handleClick, handleMouseOut, handleMouseOver
}

export default periodHoverElementEventHandlers;
