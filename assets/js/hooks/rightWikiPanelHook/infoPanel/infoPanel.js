// @ts-check
import * as d3 from "d3";
import infoPanelTransitions from "./transitions";

let currentPageId, selectedPageId, pageInfo;

function selectEl() {
    return d3.select("#infoPanel")
}

function create() {
    d3.select(".container")
        .append("div")
        .attr("id", "infoPanel")
        .style("width", "40%")
        .style("transform", "translateY(5px)")
        .style("opacity", "0")
        .html("<div>Loading...</div>")
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
        .style("width", updated == "true" ? "60%" : "100%")
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

    console.log({
        selectedPageId, pageInfo, currentPageId
    });

    if (!pageInfo || currentPageId != selectedPageId) {
        pageInfo = await getPageHTML(selectedPageId);
        currentPageId = selectedPageId;
        selectEl()
            .html(pageInfo)
    }
}

async function getPageHTML(pageId) {
    const baseURL = "https://en.wikipedia.org/w/api.php?origin=*&format=json&";
    const queryParams = "action=parse&prop=text&pageid=";

    const requestOptions = {
        method: 'GET',
    };


    const res = await fetch(baseURL + queryParams + pageId, requestOptions);
    const data = await res.json();
    return data.parse.text["*"];
}

const infoPanel = {
    selectEl, create, toggleVisibility
}

export default infoPanel;