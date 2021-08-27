// @ts-check

import moment from "moment";
import { TimePeriod } from "./types";

const subPeriodTransforms = {
    transform,
};

export default subPeriodTransforms;

function transform(periods: TimePeriod[]) {
    let flattened: TimePeriod[] = [];
    let startTimes: number[] = [];
    let endTimes: number[] = [];

    flattenPeriods(periods, 1);

    function sortByDateTime(
        periods: TimePeriod[],
        depth: number
    ): TimePeriod[] {
        let with_times = periods.map((d) => {
            d.start = moment(d.start_datetime, moment.ISO_8601).unix();
            d.end = moment(d.end_datetime, moment.ISO_8601).unix();
            d.depth = depth;

            startTimes.push(d.start);
            endTimes.push(d.end);
            return d;
        });

        return with_times.sort((a, b) => {
            return a.start - b.start;
        });
    }

    function flattenPeriods(periods: TimePeriod[], depth: number) {
        let sorted = sortByDateTime(periods, depth);
        sorted.map((p) => {
            flattened.push(p);
            if (p.expand && Array.isArray(p.sub_time_periods)) {
                flattenPeriods(p.sub_time_periods, depth + 1);
            }
        });
    }

    let beginning = Math.min(...startTimes);
    let ending = Math.max(...endTimes);
    let denom = moment(ending).diff(beginning);
    return flattened.map((p, i) => {
        p.width = (moment(p.end).diff(p.start) / denom) * 100 + "%";
        p.ml = (moment(p.start).diff(beginning) / denom) * 100 + "%";
        p.sub_time_periods = countSubPeriods(flattened, p.depth, i);

        return p;
    });
}

function countSubPeriods(periods: TimePeriod[], depth: number, index: number) {
    const depthArr = periods.map((p) => p.depth);
    const rest = depthArr.slice(index + 1);
    const next = rest.findIndex((el: number) => el <= depth);
    if (next < 0) return rest.length + 1;
    return next + 1;
}
