// @ts-check
import * as d3 from "d3";
import enableToggleButtonEventHandlers from "./eventHandlers";

function selectEl() {
    d3.select("#wikiPanelToggle")
}

function create() {
    d3.select("body")
        .append("div")
        .attr("id", "wikiPanelToggle")
        .text("Toggle")
        .call(enableToggleButtonEventHandlers)
}


const toggleButton = {
    create, selectEl
}

export default toggleButton;