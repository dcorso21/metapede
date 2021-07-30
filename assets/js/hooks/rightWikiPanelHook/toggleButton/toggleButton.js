// @ts-check
import * as d3 from "d3";

function create() {
    d3.select(".container")
        .append("div")
        .style("position", "absolute")
        .style("top", "0")
        .style("right", "0")
        .style("width", "100px")
        .style("height", "100px")
        .text("Toggle")
}

const toggleButton = {
    create
}

export default toggleButton;