// @ts-check
import * as d3 from "d3";
import infoPanelTransitions from "./transitions";

let currentPageId: string | null;
let selectedPageId: string | null;
let pageInfo: string | null;

function selectEl() {
    return d3.select("#infoPanel");
}

function create() {
    d3.select(".container")
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

    d3.select("#left_info")
        .call(() => {
            if (!isOpen) {
                hide();
            }
        })
        .transition()
        .duration(200)
        .ease(d3.easeCircle)
        .style("width", isOpen ? "60%" : "100%")
        .on("end", () => {
            if (isOpen) {
                show();
            }
        });
}

function show() {
    selectEl().call(setHTML).call(infoPanelTransitions.fadeIn);
}

function hide() {
    selectEl().call(infoPanelTransitions.fadeOut);
}

async function setHTML() {
    selectedPageId = window.sessionStorage.getItem("selectedPageId");

    if (!pageInfo || currentPageId != selectedPageId) {
        pageInfo = await getPageHTML(selectedPageId);
        currentPageId = selectedPageId;
        selectEl().html(pageInfo);
    }
}

async function getPageHTML(pageId: string | null) {
    if (!pageId) {
        return "<div>Problem with Page Id</div>"
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
};

export default infoPanel;
