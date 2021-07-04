import * as d3 from "d3";
import moment from "moment";

const tlFuncs = {
    height: 30,
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

        return data;
    },

    render(el) {
        let sub_periods = JSON.parse(el.dataset.sub_periods);
        console.log(sub_periods);
        sub_periods = this.transform(sub_periods);

        d3.select(el)
            .selectAll(".sub_period")
            .data(sub_periods, (d) => d.id) // ID for tracking
            .join(this.enterPeriods, this.updatePeriods, this.exitPeriods);
    },

    enterPeriods(enter) {
        return enter
            .append("div")
            .attr("class", "sub_period")
            .text((d) => d.topic.title);

        // .style("left", (d) => d.x)
        // .style("top", (_, i) => this.height * i + "px")
        // .style("height", () => this.height + "px")
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
                .style("top", (_, i) => i * this.height + "px");
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
