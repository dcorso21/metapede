const duration = 300;

function fadeIn(selection) {
    selection
        .style("z-index", 10)
        .transition()
        .duration(duration)
        .style("opacity", 1)
}

function fadeOut(selection) {
    selection
        .style("z-index", -10)
        .transition()
        .duration(duration)
        .style("opacity", 0)
}


const infoPanelTransitions = {
    fadeIn, fadeOut
}

export default infoPanelTransitions;