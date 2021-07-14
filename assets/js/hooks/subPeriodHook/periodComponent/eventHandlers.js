// @ts-check
import periodContextMenu from "./contextMenu/contextMenu";
import { getHoverElement } from "./hoverInfo/eventHandlers"
import HoverInfoElement from "./hoverInfo/hoverInfo"
import { hoverInfoFadeIn, hoverInfoFadeOut } from "./hoverInfo/transitions"

// @ts-ignore
const conn = global.subPeriodsConn;


export default function addAllPeriodEventListeners(selection) {
	selection
		.on("mouseover", handleMouseOver)
		.on("mouseout", handleMouseOut)
		.on("click", handleClick)
		.on("contextmenu", handleContextMenu)
}

function handleMouseOver(e, per) {
	const hoverInfo = getHoverElement()

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
	const hoverInfo = getHoverElement()
	// @ts-ignore
	const elementIsInside = hoverInfo.node().contains(e.toElement)
	const isHoverInfo = hoverInfo.node() == e.toElement
	if (elementIsInside || isHoverInfo) return;
	hoverInfo.call(hoverInfoFadeOut)
}

function handleClick(_e, period) {
	conn.pushEvent("click_period", period);
}

function handleContextMenu(e, period) {
	e.preventDefault();
	periodContextMenu.create(e, period)
}