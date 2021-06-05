import * as d3 from "d3";

const SearchHook = {
    wikiInfo() {
        return this.el.dataset.myinfo;
    },
    mounted() {
        let info = this.wikiInfo();
        console.log(info);
        if (!!info) {
            d3.select(this.el).append("div").text(info);
        }
    },
    updated() {
        console.log(this.wikiInfo());
    },
};

export default SearchHook;
