import { getSubPeriodsConn } from "../../subPeriodHook";
import { TimePeriod } from "../../types";
import HoverInfoElement from "./hoverInfo";
import { hoverInfoFadeIn, hoverInfoFadeOut } from "./transitions";

function handleMouseOver(e: Event, per: TimePeriod) {
    const hoverInfo = HoverInfoElement.selectEl();
    HoverInfoElement.updateInfo(hoverInfo, per);
    // @ts-ignore
    let { x, y, width } = e.target.getBoundingClientRect();
    // @ts-ignore
    const hoverBox = hoverInfo.node().getBoundingClientRect();
    const left = x + width / 2 - hoverBox.width / 2;
    const top = y - hoverBox.height + window.scrollY;

    hoverInfo
        .style("left", left + "px")
        .style("top", top + "px")
        .call(hoverInfoFadeIn);
}

function handleMouseOut(e: MouseEvent) {
    if (isHoverElement(e)) return;
    HoverInfoElement.selectEl().call(hoverInfoFadeOut);
}

function isHoverElement(e: MouseEvent) {
    const hoverInfo = HoverInfoElement.selectEl();
    // @ts-ignore
    const elementIsInside = hoverInfo.node().contains(e.toElement);
    // @ts-ignore
    const isHoverInfo = hoverInfo.node() == e.toElement;
    return elementIsInside || isHoverInfo;
}

function handleClick(period: TimePeriod) {
    console.log({ period });
    HoverInfoElement.selectEl().style("opacity", "0");
    getSubPeriodsConn().sendEvent("click_period_title", period._id);
}

const periodHoverElementEventHandlers = {
    handleClick,
    handleMouseOut,
    handleMouseOver,
};

export default periodHoverElementEventHandlers;
