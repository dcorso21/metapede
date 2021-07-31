// @ts-check
import * as d3 from "d3";
import infoPanelTransitions from "./transitions";


let currentPageId, selectedPageId, pageInfo;

function selectEl() {
    return d3.select("#infoPanel")
}

function create(page_id) {
    d3.select(".container")
        .append("div")
        .attr("id", "infoPanel")
        .style("width", "40%")
        .style("transform", "translateY(5px)")
        .style("opacity", "0")
        .html("<div>Loading...</div>")
        // .call(async selection => {
        //     const html = await getPageText(page_id)
        //     selection.html(html)
        // })
}

function toggleVisibility() {
    const open = window.localStorage.getItem("rightWikiPanelOpen");
    const updated = open == "true" ? "false" : "true";
    const callback = updated == "true" ? show : hide;
    window.localStorage.setItem("rightWikiPanelOpen", updated);

    d3.select("#left_info")
        .transition()
        .duration(200)
        .ease(d3.easeCircle)
        .style("width", open == "true" ? "60%" : "100%")
        .on("end", callback)
}

function show() {
    selectEl()
        .call(setHTML)
        .call(infoPanelTransitions.fadeIn)
}

function hide() {
    selectEl()
        .call(infoPanelTransitions.fadeOut)
}

async function setHTML() {
    selectedPageId = window.sessionStorage.getItem("selectedPageId")

    if (!pageInfo || currentPageId != selectedPageId) {
        pageInfo = await getPageText(selectedPageId);
        currentPageId = selectedPageId;
    }

    selectEl()
        .html(pageInfo)
}

async function getPageText(pageId) {
    const baseURL = "https://en.wikipedia.org/w/api.php?origin=*&format=json&";
    const queryParams = "action=parse&prop=text&pageid=";

    const requestOptions = {
        method: 'GET',
    };

    console.log({pageId});

    const res = await fetch(baseURL + queryParams + pageId, requestOptions);
    console.log({res});
    const data = await res.json();
    console.log({data});
    return data.parse.text["*"];
}
// function getPageText(page_id) {
//     const baseURL = "https://en.wikipedia.org/w/api.php?origin=*&format=json&";
//     const queryParams = "action=parse&prop=text&pageid=";

//     const requestOptions = {
//         method: 'GET',
//     };

//     return fetch(baseURL + queryParams + page_id, requestOptions)
//         .then((res) => res.json())
//         .then(res => res.parse.text["*"]);
// }

const infoPanel = {
    selectEl, create, toggleVisibility
}

export default infoPanel;