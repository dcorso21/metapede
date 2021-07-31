const duration = 300;

function fadeIn(selection) {
    selection
        .transition()
        .duration(duration)
        .style("opacity", 1)
}

function fadeOut(selection) {
    selection
        .transition()
        .duration(duration)
        .style("opacity", 0)
}


const infoPanelTransitions = {
    fadeIn, fadeOut
}

export default infoPanelTransitions;