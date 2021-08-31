import * as d3 from "d3";
import rightWikiPanelHook from "../rightWikiPanelHook";
import infoPanelTransitions from "./transitions";

let openState: boolean = false;
let currentPageId: string = "";

function selectEl() {
    return d3.select("#infoPanel");
}

function create() {
    d3.select("body")
        .append("div")
        .attr("id", "infoPanel")
        .style("width", "40%")
        .style("transform", "translateY(5px)")
        .style("opacity", "0")
        .html("<div>Loading...</div>");
}

function toggleVisibility() {
    const wasOpen = window.localStorage.getItem("rightWikiPanelOpen");
    const updatedVal = wasOpen == "true" ? "false" : "true";
    const isOpen = updatedVal == "true";
    console.log({ isOpen, wasOpen });
    window.localStorage.setItem("rightWikiPanelOpen", updatedVal);

    d3.select(".container")
        .call(() => {
            if (!isOpen) hide();
        })
        .transition()
        .duration(200)
        .ease(d3.easeCircle)
        .style("width", isOpen ? "60%" : "100%")
        .on("end", () => {
            if (isOpen) show();
        });
}

function show() {
    d3.select(".container")
        .transition()
        .duration(200)
        .ease(d3.easeCircle)
        .style("width", "55%")
        .style("margin", "2.5%");

    selectEl().call(setHTML).call(infoPanelTransitions.fadeIn);
    openState = !openState;
}

function hide() {
    selectEl().call(infoPanelTransitions.fadeOut);
}

function isOpen() {
    return openState;
}

async function setHTML() {
    let pageId = rightWikiPanelHook.getConn().getVar("page_id");
    console.log({pageId, currentPageId});
    if(pageId !== currentPageId) {
        let el = selectEl();
        el.html("Loading...");
        let pageInfo = await getPageHTML(pageId);
        el.html(pageInfo);
        currentPageId = pageId;
    }
}

async function getPageHTML(pageId: string | null) {
    if (!pageId) {
        return "<div>Problem with Page Id</div>";
    }
    const baseURL = "https://en.wikipedia.org/w/api.php?origin=*&format=json&";
    const queryParams = "action=parse&prop=text&pageid=";

    const requestOptions = {
        method: "GET",
    };

    const res = await fetch(baseURL + queryParams + pageId, requestOptions);
    const data = await res.json();
    const title = data.parse.title;
    const bodyContent = data.parse.text["*"];
    return `<h1>${title}</h1>` + bodyContent;
}

const infoPanel = {
    selectEl,
    create,
    toggleVisibility,
    show,
    hide,
    isOpen,
};

export default infoPanel;
