import { handleMouseOut, handleClick } from "./eventHandlers";


export function selectEl() {
	return d3.select("#hoverInfo");
}


function createBlank() {
	d3.select("body")
		.append("div")
		.on("mouseout", handleMouseOut)
		.style("position", "absolute")
		.style("transform", "translateY(5px)")
		.attr("class", "hoverInfo")
		.attr("id", "hoverInfo")
		.call((enter) => {
			enter.append("img");
			enter.append("div").attr("class", "title");
			enter.append("div").attr("class", "desc");
		});
}

function updateInfo(selection, period) {
	selection.select("img").attr("src", period.topic.thumbnail);
	selection.select(".title").text(period.topic.title).on("click", () => handleClick(period));
	selection.select(".desc").text(period.topic.description);
}

const HoverInfoElement = { createBlank, updateInfo }
export default HoverInfoElement;