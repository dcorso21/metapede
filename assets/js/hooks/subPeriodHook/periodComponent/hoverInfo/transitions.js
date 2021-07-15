export function hoverInfoFadeIn(select) {
	select.transition()
		.duration(200)
		.style("transform", "translateY(0px)")
		.style("opacity", "1")
}

export function hoverInfoFadeOut(select) {
	select.transition()
		.duration(600)
		.style("opacity", "0")
		.style("transform", "translateY(5px)")
}