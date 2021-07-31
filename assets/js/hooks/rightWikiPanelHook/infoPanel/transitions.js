const duration = 300;

function fadeIn(selection) {
    selection
        .transition()
        .duration(duration)
        .style("opacity", 1)
        .style("z-index", 10)
}

function fadeOut(selection) {
    selection
        .transition()
        .duration(duration)
        .style("opacity", 0)
        .style("z-index", -10)
}


const infoPanelTransitions = {
    fadeIn, fadeOut
}

export default infoPanelTransitions;