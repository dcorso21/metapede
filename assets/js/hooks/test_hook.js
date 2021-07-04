import * as d3 from "d3";
import moment from "moment";

const tlFuncs = {
    height: 60,
    delay: 30,
    transform(data) {
        if (!data.length) return data;
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

    render(el) {
        let sub_periods = JSON.parse(el.dataset.sub_periods);
        let main_period = JSON.parse(el.dataset.main_period);
        console.log({ sub_periods, main_period });
        sub_periods = this.transform(sub_periods);

        d3.select(el)
            .style("height", sub_periods.length * this.height + "px")
            .selectAll(".sub_period")
            .data(sub_periods, (d) => d.id) // ID for tracking
            .join(this.enterPeriods, this.updatePeriods, this.exitPeriods);
    },

    enterPeriods(enter) {
        return enter
            .append("div")
            .attr("class", "sub_period")
            .text((d) => d.topic.title)
            .style("width", (d) => d.width)
            .style("left", (d) => d.ml)
            .style("top", (_, i) => tlFuncs.height * i + "px")
            .style("height", () => tlFuncs.height + "px");
        // .style("left", (d) => d.x)
        // .style("width", (d) => d.width)
        // .call((enter) => {
        //     enter
        //         // .transition(tlRenderer.standardTrans())
        //         .style("opacity", 1);
        // });
    },

    updatePeriods(update) {
        let delayInd = -1;
        return update.call((update) => {
            update
                // .transition(tlRenderer.standardTrans)
                // .delay(() => {
                //     delayInd++;
                //     return delayInd * this.delay;
                // })
                .style("top", (_, i) => i * this.height + "px")
                .style("width", (d) => d.width);
        });
    },

    exitPeriods(exit) {
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

export default {
    mounted() {
        tlFuncs.render(this.el);
    },
    updated() {
        tlFuncs.render(this.el);
    },
};
