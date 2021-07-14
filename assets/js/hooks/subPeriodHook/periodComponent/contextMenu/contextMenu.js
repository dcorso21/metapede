function create(e, _period) {
    d3.select("#periodContext")
        .remove()

    enableClickout()
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