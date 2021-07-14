export function setHeightTransition(select, totalHeight) {
	select
		.transition()
		.duration(200)
		.style("height", totalHeight + "px")
}