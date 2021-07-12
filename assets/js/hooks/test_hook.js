import * as d3 from "d3";
import moment from "moment";


let hovering = false;


function hoverCard(enter, period) {
    enter.select("img").attr("src", period.topic.thumbnail);
    enter.select(".title").text(period.topic.title);
    enter.select(".desc").text(period.topic.description);
}

function createHoverElement() {
    const el = d3
        .select("body")
        .append("div")
        .on("mouseout", () => {
            hovering = false;
            d3.select(".hoverInfo").style("display", "none");
        })
        .style("position", "absolute")
        .style("display", "block")
        .attr("class", "hoverInfo")
        .attr("id", "hoverInfo")
        .call((enter) => {
            enter.append("img");
            enter.append("div").attr("class", "title");
            enter.append("div").attr("class", "desc");
        });
}


function handleMouseOver(e, per) {
    let { x, y, width } = e.target.getBoundingClientRect()
    const hoverBox = d3.select(".hoverInfo").node().getBoundingClientRect()
    const left = x + (width / 2) - (hoverBox.width / 2)
    const top = y - hoverBox.height;
    hovering = true;

    d3.select(".hoverInfo")
        .style("display", "block")
        .call((enter) => hoverCard(enter, per))
        .style("left", left + "px")
        .style("top", top + "px");
}


function handleMouseOut(e, per) {
    if (e.toElement.id == "hoverInfo") return;
    hovering = false;
    d3.select(".hoverInfo").style("display", "none");
}


let tlFuncs = {
    height: 30,
    delay: 30,
    element: null,
    flatten(periods) {
        let to_add = periods.map((p) => {
            if (p.expand && Array.isArray(p.sub_time_periods)) {
                return this.flatten(p.sub_time_periods);
            }
            return [];
        });

        let subs = to_add.reduce((a, b) => [...a, ...b], []);
        return [...periods, ...subs];
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

        // Init with first period
        createHoverElement();

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
            .on("mouseover", (e, d) => handleMouseOver(e, d))
            .on("mouseout", (e, d) => handleMouseOut(e, d))
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
        Tester.ref.pushEvent("click_period", periodData);
    },
};

export default Tester;
