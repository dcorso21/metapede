const duration = 300;

function fadeIn(selection: d3.Selection<any, any, any, any>) {
    selection
        .style("z-index", 10)
        .transition()
        .duration(duration)
        .style("opacity", 1);
}

function fadeOut(selection: d3.Selection<any, any, any, any>) {
    selection
        .style("z-index", -10)
        .transition()
        .duration(duration)
        .style("opacity", 0);
}

const infoPanelTransitions = {
    fadeIn,
    fadeOut,
};

export default infoPanelTransitions;
