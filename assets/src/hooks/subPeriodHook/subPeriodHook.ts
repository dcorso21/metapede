import * as d3 from "d3";
import HoverInfo from "./periodComponent/hoverInfo/hoverInfo";
import periodComponent from "./periodComponent/period";
import subPeriodTransforms from "./transforms";
import { setHeightTransition } from "./transitions";

let subPeriodsConn: any;

const target:string = "#sub_period_wrap";

export function getSubPeriodsConn() {
    subPeriodsConn.sendEvent = (event: string, payload: object) =>
        subPeriodsConn.pushEventTo(target, event, payload);
    return subPeriodsConn;
}

function render(conn) {
    const phxElement = conn.el;
    let sub_periods = JSON.parse(phxElement.dataset.sub_periods);
    sub_periods = subPeriodTransforms.transform(sub_periods);

    d3.select(phxElement)
        .call((select) =>
            setHeightTransition(select, sub_periods.length * periodHeight)
        )
        .selectAll(".sub_period")
        .data(sub_periods, (d: any) => d.id)
        .join(
            periodComponent.enter,
            periodComponent.update,
            periodComponent.exit
        );
}

function mounted() {
    HoverInfo.createBlank();
    subPeriodsConn = this;
    render(this);
}

function updated() {
    subPeriodsConn = this;
    render(this);
}

const subPeriodHook = {
    mounted,
    updated,
};

export default subPeriodHook;
