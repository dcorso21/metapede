import * as d3 from "d3";
import moment from "moment";
// import { transition } from "d3";


function getTrans() {
    return d3.transition()
        .duration(150)
        .ease(d3.easeBackInOut);
}


function updateHoverInfo(period) {
    let h = d3.select("#hoverInfo")
    h.select("img").attr("src", period.topic.thumbnail);
    h.select(".title").text(period.topic.title);
    h.select(".desc").text(period.topic.description);
}

function createHoverElement() {
    d3.select("body")
        .append("div")
        .on("mouseout", handleMouseOut)
        .style("position", "absolute")
        .style("transform", "translateY(5px)")
        .attr("class", "hoverInfo")
        .attr("id", "hoverInfo")
        .call((enter) => {
            enter.append("img");
            enter.append("div").attr("class", "title");
            enter.append("div").attr("class", "desc");
        });
}


function handleMouseOver(e, per) {
    updateHoverInfo(per)
    let { x, y, width } = e.target.getBoundingClientRect()
    const hoverBox = d3.select(".hoverInfo").node().getBoundingClientRect()
    const left = x + (width / 2) - (hoverBox.width / 2)

    const top = y - hoverBox.height + window.scrollY;

    d3.select(".hoverInfo")
        .style("left", left + "px")
        .style("top", top + "px")
        .transition()
        .duration(200)
        .style("transform", "translateY(0px)")
        .style("opacity", "1")
}


function handleMouseOut(e, per) {
    const he = d3.select("#hoverInfo")
    const check = he.node().contains(e.toElement) || he.node() == e.toElement
    if (check) return;
    he.transition()
        .duration(600)
        .style("opacity", "0")
        .style("transform", "translateY(5px)")
    // .style("pointer-events", "none")
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
            .on("mouseover", (e, d) => handleMouseOver(e, d))
            .on("mouseout", (e, d) => handleMouseOut(e, d))
            .attr("class", "sub_period")
            .style("left", (d) => d.ml)
            .style("top", (_, i) => tlFuncs.height * i + "px")
            .style("height", () => "0px")
            .style("width", (d) => "0px")
            .text((d) => d.topic.title)
            .style("color", "rgba(255, 255, 255, 0.0)")
            .call(select => {
                select
                    .transition()
                    .duration(150)
                    .ease(d3.easeElasticIn)
                    .delay((_d, i) => 50 * i)
                    .style("width", (d) => d.width)
                    .style("height", () => tlFuncs.height + "px")
                    .transition()
                    .duration(150)
                    .ease(d3.easeElasticIn)
                    .style("color", "inherit")
            })
    },

    updatePeriods(update, conn) {
        let delayInd = -1;
        return update.call((update) => {
            update
                .style("top", (_, i) => i * this.height + "px")
                .style("width", (d) => d.width)
                .call(select => {
                    select
                        .style("width", (d) => d.width)
                        .style("height", () => tlFuncs.height + "px")
                })
        });
    },

    exitPeriods(exit, conn) {
        let delayInd = -1;
        return exit.call((exit) => {
            exit
                .transition()
                .duration(30)
                .ease(d3.easeBackInOut)
                .style("color", "rgba(255, 255, 255, 0)")
                .transition()
                .duration(150)
                .ease(d3.easeBackInOut)
                .style("width", "0px")
                .style("height", "0px")
                .style("opacity", "0")
                .remove();
        });
    },
};

const Tester = {
    ref: undefined,
    mounted() {
        createHoverElement();
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
