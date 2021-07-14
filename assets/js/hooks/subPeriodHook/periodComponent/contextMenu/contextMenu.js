// @ts-check
import * as d3 from "d3";
import periodContextMenuEventHandlers from "./eventHandlers";

function selectEl() {
    return d3.select("#periodContext")
}

function create(e, _period) {
    // remove any previous menu
    selectEl().remove()

    let clickY = e.clientY + window.scrollY;

    let options = [
        "Unlink Period",
        "Delete Period"
    ]

    d3.select("body")
        .append("div")
        .attr("id", "periodContext")
        .style("left", e.clientX + "px")
        .style("top", clickY + "px")
        .call(periodContextMenuEventHandlers.enableEventHandlers)
        .call(select => {
            options.map(o => {
                select.append("div")
                    .attr("class", "option")
                    .text(o)
            })
        })
}

const periodContextMenu = {
	create
}

export default periodContextMenu