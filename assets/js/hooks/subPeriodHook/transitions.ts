import { TimePeriod } from "./types";

export function setHeight(
    selection: d3.Selection<any, unknown, any, any>,
    totalHeight: number
) {
    selection
        .transition()
        .duration(200)
        .style("height", totalHeight + "px");
}
const subPeriodHookTransitions = { setHeightTransition: setHeight };
export default subPeriodHookTransitions;
