// @ts-check

import * as d3 from "d3";
import infoPanel from "./infoPanel/infoPanel";
import toggleButton from "./toggleButton/toggleButton";
let rightWikiPanelConn;




function render(conn) {
	const phxElement = conn.el;
	const page_id = phxElement.dataset.page_id;
}

function initAllElements() {
	toggleButton.create();
	infoPanel.create();
}

function initState(conn) {
	window.sessionStorage.setItem("open", "false");
	window.sessionStorage.setItem("selectedPageId", conn.el.dataset.page_id);
}

function mounted() {
	initAllElements();
	initState(this);
	render(this);
}

function updated() {
	render(this);
}

const rightWikiPanelHook = {
	mounted,
	updated
}

export default rightWikiPanelHook;





// function addFloating(open, page_id) {
// 	if (open == "true") {
// 		removeFloating();

// 		d3.select(".container")
// 			.append("div")
// 			.attr("class", "floating_info")
// 			.style("width", "40%")
// 			.style("transform", "translateY(5px)")
// 			.style("opacity", "0")
// 			.html("<div>Loading...</div>")
// 			.call(async selection => {
// 				const html = await getPageText(page_id)
// 				selection.html(html)
// 			})
// 	}
// }

// function showFloating(open) {
// 	if (open == "true") {
// 		d3.select(".floating_info")
// 			.transition()
// 			.duration(500)
// 			.style("transform", "translateY(0px)")
// 			.style("opacity", "1")
// 	}
// }

// function removeFloating() {
// 	d3.selectAll(".floating_info")
// 		.transition()
// 		.duration(500)
// 		.style("transform", "translateY(5px)")
// 		.style("opacity", "0")
// 		.on("end", select => select.remove())
// }

// function renderRightInfo(conn) {
// 	rightWikiPanelConn = conn;
// 	const phxElement = conn.el;
// 	const page_id = phxElement.dataset.page_id;
// 	const open = phxElement.dataset.open;

// 	if (open != "true") {
// 		removeFloating();
// 	}

// 	addFloating(open, page_id);


// 	d3.select("#left_info")
// 		.transition()
// 		.duration(200)
// 		.ease(d3.easeCircle)
// 		.style("width", open == "true" ? "60%" : "100%")
// 		.on("end", () => showFloating(open))
// }