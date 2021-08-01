import { TimePeriod } from "./types";

export function setHeightTransition(
    selection: d3.Selection<HTMLElement, TimePeriod, HTMLElement, any>,
    totalHeight: number
) {
    selection
        .transition()
        .duration(200)
        .style("height", totalHeight + "px");
}
