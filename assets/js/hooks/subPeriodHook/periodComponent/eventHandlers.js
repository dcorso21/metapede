// @ts-check
import periodContextMenu from "./contextMenu/contextMenu";
import periodHoverElementEventHandlers from "./hoverInfo/eventHandlers";


// @ts-ignore
const conn = global.subPeriodsConn;


export default function addAllPeriodEventListeners(selection) {
	selection
		.on("mouseover", periodHoverElementEventHandlers.handleMouseOver)
		.on("mouseout", periodHoverElementEventHandlers.handleMouseOut)
		.on("click", handleClick)
		.on("contextmenu", handleContextMenu)
}

function handleClick(_e, period) {
	conn.pushEvent("click_period", period);
}

function handleContextMenu(e, period) {
	e.preventDefault();
	periodContextMenu.create(e, period)
}