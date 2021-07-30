// @ts-check
import { getSubPeriodsConn } from "../subPeriodHook";
import periodContextMenu from "./contextMenu/contextMenu";
import expandCaretComponent from "./expandCaret/expandCaret";
import periodHoverElementEventHandlers from "./hoverInfo/eventHandlers";


export default function addAllPeriodEventListeners(selection) {
	selection
		.on("mouseover", periodHoverElementEventHandlers.handleMouseOver)
		.on("mouseout", periodHoverElementEventHandlers.handleMouseOut)
		.on("click", handleClick)
		.on("contextmenu", handleContextMenu)
}

function handleClick(_e, period) {
	expandCaretComponent.toggleTransition(period)
	getSubPeriodsConn().sendEvent("click_period_body", period.id);
}

function handleContextMenu(e, period) {
	e.preventDefault();
	periodContextMenu.create(e, period)
}