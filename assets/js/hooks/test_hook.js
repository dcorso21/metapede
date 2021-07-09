import * as d3 from "d3";
import moment from "moment";

let tlFuncs = {
    height: 60,
    delay: 30,
    element: null,
    flatten(periods) {
        let to_add = periods.map(p => {
            if (p.expand && Array.isArray(p.sub_time_periods)) {
                return this.flatten(p.sub_time_periods)
            }
            return []
        })

        let subs = to_add.reduce((a, b) => [...a, ...b])
        return [...periods, ...subs]

        // function recur(period) {
        //     flat_arr = [...flat_arr, period];
        //     if (period.expand && Array.isArray(period.sub_time_periods)) {
        //         flat_arr = [...flat_arr, ...period.sub_time_periods];
        //         let for_add = period.sub_time_periods.map(recur);
        //         for_add.reduce((a, b) => [...a, ...b]);
        //         flat_arr = [...flat_arr, ...for_add];
        //     }
        //     return flat_arr;
        // }
    },
    transform(data) {
        if (!data.length) return data;

        data = tlFuncs.flatten(data);

        let with_times = data.map((d) => {
            d.start = moment(d.start_datetime, moment.ISO_8601);
            d.end = moment(d.end_datetime, moment.ISO_8601);
            return d;
        });

        let beginning = with_times.reduce((a, b) => {
            return a.start < b.start ? a : b;
        }).start;

        let ending = with_times.reduce((a, b) => {
            return a.end > b.end ? a : b;
        }).end;

        console.log({ beginning, ending });

        let denom = moment(ending).diff(beginning);

        let periods = with_times.map((p) => {
            p.width = (moment(p.end).diff(p.start) / denom) * 100 + "%";
            p.ml = (moment(p.start).diff(beginning) / denom) * 100 + "%";
            return p;
        });

        return periods.sort((a, b) => {
            return a.start.unix() - b.start.unix();
        });
    },

    render(el, conn) {
        this.element = el;
        let sub_periods = JSON.parse(el.dataset.sub_periods);
        // let main_period = JSON.parse(el.dataset.main_period);
        sub_periods = this.transform(sub_periods);

        d3.select(el)
            .style("height", sub_periods.length * this.height + "px")
            .selectAll(".sub_period")
            .data(sub_periods, (d) => d.id) // ID for tracking
            .join(
                (enter) => this.enterPeriods(enter, conn),
                (update) => this.updatePeriods(update, conn),
                (exit) => this.exitPeriods(exit, conn)
            );
    },

    enterPeriods(enter, conn) {
        return enter
            .append("div")
            .on("click", (_e, d) => Tester.handleClick.bind(conn, d)())
            .attr("class", "sub_period")
            .text((d) => d.topic.title)
            .style("width", (d) => d.width)
            .style("left", (d) => d.ml)
            .style("top", (_, i) => tlFuncs.height * i + "px")
            .style("height", () => tlFuncs.height + "px");
    },

    updatePeriods(update, conn) {
        let delayInd = -1;
        return update.call((update) => {
            update
                .style("top", (_, i) => i * this.height + "px")
                .style("width", (d) => d.width);
            // .transition(tlRenderer.standardTrans)
            // .delay(() => {
            //     delayInd++;
            //     return delayInd * this.delay;
            // })
        });
    },

    exitPeriods(exit, conn) {
        let delayInd = -1;
        return exit.call((exit) => {
            exit
                // .transition(tlRenderer.standardTrans)
                // .delay(() => {
                //     delayInd++;
                //     return delayInd * tlRenderer.delay;
                // })
                .style("opacity", "0")
                .remove();
        });
    },
};

const Tester = {
    ref: undefined,
    mounted() {
        Tester.ref = this;
        tlFuncs.render(this.el, this);
    },
    updated() {
        Tester.ref = this;
        tlFuncs.render(this.el);
    },
    handleClick(periodData) {
        console.log(`pushing ${periodData.topic.title} to the server`);
        Tester.ref.pushEvent("click_period", periodData);
    },
};

export default Tester;
