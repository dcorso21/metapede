import { getSubPeriodsConn } from "../subPeriodHook";
import { TimePeriod } from "../types";
import periodContextMenu from "./contextMenu/contextMenu";
import expandCaretComponent from "./expandCaret/expandCaret";
import periodHoverElementEventHandlers from "./hoverInfo/eventHandlers";

export default function addAllPeriodEventListeners(
    selection: d3.Selection<HTMLDivElement, TimePeriod, HTMLElement, any>
) {
    selection
        .on("mouseover", periodHoverElementEventHandlers.handleMouseOver)
        .on("mouseout", periodHoverElementEventHandlers.handleMouseOut)
        .on("click", handleClick)
        .on("contextmenu", handleContextMenu);
}

function handleClick(e: MouseEvent, period: TimePeriod) {
    e.preventDefault();
    expandCaretComponent.toggleTransition(period);
    getSubPeriodsConn().sendEvent("click_period_body", period.id);
}

function handleContextMenu(e: MouseEvent, period: TimePeriod) {
    e.preventDefault();
    periodContextMenu.create(e, period);
}