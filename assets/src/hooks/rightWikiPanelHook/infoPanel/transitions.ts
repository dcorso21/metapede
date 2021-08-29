import d3 from "d3";

const duration = 300;

function fadeIn(selection: d3.Selection<any, any, any, any>) {
            selection
                    .style("z-index", 10)
                .transition()
                .duration(duration)
                .style("opacity", 1);
    // d3.select(".container")
    //     .transition()
    //     .duration(200)
    //     .ease(d3.easeCircle)
    //     .style("width", "60%")
    //     .on("end", () => {
    //     });
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
