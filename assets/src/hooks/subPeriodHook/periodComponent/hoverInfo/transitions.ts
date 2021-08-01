import { TimePeriod } from "../../types"

export function hoverInfoFadeIn(
    selection: d3.Selection<HTMLElement, TimePeriod, HTMLElement, any>,
) {
	selection
		.style("z-index", "15")
		.transition()
		.duration(200)
		.style("transform", "translateY(0px)")
		.style("opacity", "1")
}

export function hoverInfoFadeOut(
    selection: d3.Selection<HTMLElement, TimePeriod, HTMLElement, any>,
) {
	selection.transition()
		.duration(600)
		.style("opacity", "0")
		.style("transform", "translateY(5px)")
		.style("z-index", "-10")
}