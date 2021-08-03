import * as d3 from "d3";
import HoverInfo from "./periodComponent/hoverInfo/hoverInfo";
import periodComponent from "./periodComponent/period";
import subPeriodTransforms from "./transforms";
import subPeriodHookTransitions from "./transitions";

let subPeriodsConn: any;

const target: string = "#sub_period_wrap";

export function getSubPeriodsConn() {
    subPeriodsConn.sendEvent = (event: string, payload: any) =>
        subPeriodsConn.pushEventTo(target, event, payload);
    return subPeriodsConn;
}

function render(): void {
    const phxElement = subPeriodsConn.el;
    let sub_periods = JSON.parse(phxElement.dataset.sub_periods);
    sub_periods = subPeriodTransforms.transform(sub_periods);

    d3.select(phxElement)
        .call((selection) =>
            subPeriodHookTransitions.setHeightTransition(
                selection,
                sub_periods.length * periodComponent.height
            )
        )
        .selectAll(".sub_period")
        .data(sub_periods, (d: any) => d.id)
        .join(
            // @ts-ignore
            periodComponent.enter,
            periodComponent.update,
            periodComponent.exit
        );
}

function mounted(this: any) {
    HoverInfo.createBlank();
    subPeriodsConn = this;
    render();
}

function updated(this: any) {
    subPeriodsConn = this;
    render();
}

const subPeriodHook = {
    mounted,
    updated,
};

export default subPeriodHook;
