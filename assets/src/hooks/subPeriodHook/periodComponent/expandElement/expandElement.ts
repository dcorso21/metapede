// @ts-check
import * as d3 from "d3";
import { TimePeriod } from "../../types";
import periodComponent from "../period";

function selectEl(periodId: string) {
    return d3.select(`#sub_per_exp_${periodId}`);
}

function createOrPull(period: TimePeriod) {
    let el = selectEl(period.id);
    if (!el.empty()) return el;

    return periodComponent
        .selectEl(period.id)
        .append("div")
        .attr("id", `sub_per_exp_${period.id}`)
        .attr("class", "per_expansion");
}

function update(period: TimePeriod) {
    if (isExpanded(period)) {
        createOrPull(period)
            .transition()
            .duration(350)
            // @ts-ignore
            .style("height", periodComponent.height * period.sub_time_periods + "px");
    } else {
        selectEl(period.id).remove();
    }
}

function isExpanded(period: TimePeriod) {
    return period.expand && period.sub_time_periods > 1;
}

const expandComponent = { selectEl, update };

export default expandComponent;
