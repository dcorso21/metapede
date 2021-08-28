import * as d3 from "d3";
import periodTransitions from "./transitions";
import addAllPeriodEventListeners from "./eventHandlers";
import expandComponent from "./expandElement/expandElement";
import { TimePeriod } from "../types";
import expandCaretComponent from "./expandCaret/expandCaret";

const height = 30;

function selectEl(periodId: string) {
    return d3.select(`#sub_per_${periodId}`);
}

function enter(
    selection: d3.Selection<HTMLElement, TimePeriod, HTMLElement, any>
) {
    return selection
        .append("div")
        .call((select) => addAllPeriodEventListeners(select))
        .attr("class", "sub_period")
        .attr("id", (d) => "sub_per_" + d._id)
        .style("left", (d) => d.ml)
        .style("top", (_, i) => height * i + "px")
        .style("height", () => "0px")
        .style("width", () => "0px")
        .text((d) => d.topic.title)
        .style("color", "rgba(255, 255, 255, 0.0)")
        .call(periodTransitions.enterTransition)
        .each(expandCaretComponent.createEach);
}

function update(
    selection: d3.Selection<HTMLElement, TimePeriod, HTMLElement, any>
) {
    return selection.call((update) => {
        update
            .style("top", (_, i) => i * height + "px")
            .style("width", (d) => d.width)
            .style("left", (d) => d.ml)
            .each(expandComponent.update)
            .call(periodTransitions.updateTransition);
    });
}

function exit(
    selection: d3.Selection<HTMLElement, TimePeriod, HTMLElement, any>
) {
    return selection.call(periodTransitions.exitTransition);
}

const periodComponent = {
    enter,
    update,
    exit,
    selectEl,
    height,
};

export default periodComponent;
