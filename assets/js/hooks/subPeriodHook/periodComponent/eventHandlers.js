// @ts-check
import { getConn } from "../subPeriodHook";
import periodContextMenu from "./contextMenu/contextMenu";
import periodHoverElementEventHandlers from "./hoverInfo/eventHandlers";


export default function addAllPeriodEventListeners(selection) {
	selection
		.on("mouseover", periodHoverElementEventHandlers.handleMouseOver)
		.on("mouseout", periodHoverElementEventHandlers.handleMouseOut)
		.on("click", handleClick)
		.on("contextmenu", handleContextMenu)
}

function handleClick(_e, period) {
	getConn().pushEvent("click_period", period);
}

function handleContextMenu(e, period) {
	e.preventDefault();
	periodContextMenu.create(e, period)
}