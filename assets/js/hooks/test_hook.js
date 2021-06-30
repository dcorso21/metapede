import * as d3 from "d3";

export default {
    mounted() {
        let val = JSON.parse(this.el.dataset.period)
        d3.select(this.el).append("pre").text("hello");
        console.log(val)
    },
};
